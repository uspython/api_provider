/*
 * @Author: jeffzhao
 * @Date: 2019-03-19 15:19:51
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-04-02 15:38:03
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:io';

import 'package:api_datastore/api_datastore.dart' show ApiSettings, dio;
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart'
    show
        DioError,
        Interceptor,
        InterceptorsWrapper,
        RequestOptions,
        Response,
        Dio,
        BaseOptions;

import 'package:api_provider/src/cherror.dart';
import 'package:api_provider/src/api_provider_interface.dart';

typedef RequestCallbackType = dynamic Function(RequestOptions);
typedef ResponseCallbackType = dynamic Function(Response<dynamic>);
typedef ErrorCallbackType = dynamic Function(DioError);

class ProviderService {
  static final ProviderService _s = ProviderService._internal();
  factory ProviderService() {
    return _s;
  }
  ProviderService._internal();

  static Serializers get jsonSerializers => _jsonSerializers;
  static Serializers _jsonSerializers;
  static String get token => _token;
  static String _token;
  static Map<String, dynamic> get userInfo => _userInfo;
  static Map<String, dynamic> _userInfo;

  static ApiProviderInterface get providerInterface => _providerInterface;
  static ApiProviderInterface _providerInterface;

  dynamic get initializationDone => _init;

  static final _cache = Map<Uri, Response>();

  void setSerializers(Serializers s) {
    _jsonSerializers = s;
  }

  void setToken(String token) {
    _token = token;
  }

  void setUserInfo(Map<String, dynamic> info) {
    _userInfo = info;
  }

  void setProviderInterface(ApiProviderInterface interface) {
    _providerInterface = interface;
  }

  dynamic _init() {
    print('[API Provider]: Configuring initialization');
    print('[API Provider]: Token from device is:');
    print('[API Provider]: $token');

    final info = userInfo;
    final domain = isDebug() ? 'api-investor-qa' : 'api-investor';
    ApiSettings().baseUrl = 'https://$domain.city-home.cn';
    ApiSettings().connectTimeout = 60 * 1000;
    ApiSettings().receiveTimeout = 60 * 1000;
    ApiSettings().requestHeader = {
      HttpHeaders.userAgentHeader: info['ua'] as String,
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.acceptEncodingHeader: 'gzip;q=1.0, compress;q=0.5',
      HttpHeaders.acceptLanguageHeader: '${info['locale']};q=1.0',
      HttpHeaders.connectionHeader: 'keep-alive',
    };
    ApiSettings().defaultInterceptors.add(_defaultWrapper());
  }

  static bool isDebug() {
    return !(const bool.fromEnvironment('dart.vm.product'));
  }

  Interceptor _defaultWrapper() {
    final defaultRequestInterceptor = InterceptorsWrapper(
        onRequest: _onRequest, onResponse: _onResponse, onError: _onError);
    return defaultRequestInterceptor;
  }

  final RequestCallbackType _onRequest = (RequestOptions options) {
    print('[API Provider]: Processing with Default Request Interceptor');
    print(
        '[API Provider]: Sending request：path:${options.path}，baseURL:${options.baseUrl}');
    if (options.path == '/logout/') {
      // no `logout api now, resolve fade data`
      return dio.resolve(_onResponse(Response(
          request: options,
          data: {'error': {}, 'success': true, 'payload': <String, dynamic>{}},
          statusCode: HttpStatus.ok)));
    }

    // if token has refreshed, use new token
    final refreshedToken = options.headers[HttpHeaders.authorizationHeader];
    if (refreshedToken == null) {
      //no token, use the old one
      options.headers[HttpHeaders.authorizationHeader] = 'JWT $token';
    }

    if (options.path == '/token/obtain/' || options.path == '/token/refresh/') {
      options.headers.remove(HttpHeaders.authorizationHeader);
    }

    final response = _cache[options.uri];
    if (options.extra['needCached'] == false) {
      print(
          '[API Provider]: Force refreshing, ignore cache at ${options.uri} \n');
      return options;
    } else if (options.extra['needCached'] == true && response != null) {
      print('[API Provider]: Cache hitted: ${options.uri} \n');
      return response;
    }
    return options;
  };

  static final ResponseCallbackType _onResponse = (Response resp) {
    print('[API Provider]: Processing with Default Response Interceptor');
    _cache[resp.request?.uri] = resp;

    if (_httpStatusSuccess().contains(resp.statusCode)) {
      final json = (resp.data as Map<String, dynamic>) ?? {};
      if (json.containsKey('success') && (json['success'] as bool) == false) {
        throw CHError.fromJson(json['error'] as Map<String, dynamic> ?? {});
      } else if (json.containsKey('payload')) {
        return _success((json['payload'] as Map<String, dynamic>) ?? {}, resp);
      } else {
        return _success(json, resp);
      }
    }
    throw resp.data['error'] != null
        ? CHError.fromJson(resp.data['error'] as Map<String, dynamic>)
        : CHError(
            message: resp.data.toString(),
            statusCode: resp.statusCode,
            codeString: 'unkonw');
  };

  static List<int> _httpStatusSuccess() {
    return [
      HttpStatus.ok,
      HttpStatus.created,
      HttpStatus.accepted,
      HttpStatus.nonAuthoritativeInformation,
      HttpStatus.noContent,
      HttpStatus.resetContent,
      HttpStatus.partialContent,
      HttpStatus.multiStatus,
      HttpStatus.alreadyReported,
      HttpStatus.imUsed
    ];
  }

  static Map<String, dynamic> _success(
      Map<String, dynamic> json, Response resp) {
    print('[API Provider]: Got Response');
    switch (resp.request.path) {
      case '/token/obtain/':
        print('[API Provider]: Fetch token successfully.');
        providerInterface.onGotToken(json['token'].toString());
        providerInterface.onLogin();
        break;
      case '/logout/':
        print('[API Provider]: Preparing for logout');
        providerInterface.onLogout();
        break;
      default:
        break;
    }
    return json;
  }

  final ErrorCallbackType _onError = (DioError e) {
    if (e is CHError) {
      print('[API Provider]: Error Occurred, `${e.message}`');
      switch (e.statusCode.toString()) {
        case CHErrorEnum.serviceFailure:
          return e;

        case CHErrorEnum.tokenExpired:
          {
            /// Refresh Token
            // return _refreshToken(e);
            print('[API Provider]: Token expried, refresh token...');
            final options = e.request;
            // If the token has been updated, repeat directly.
            if ('JWT $token' !=
                options.headers[HttpHeaders.authorizationHeader]) {
              options.headers[HttpHeaders.authorizationHeader] = 'JWT $token';
              //repeat
              return dio.request(options.path, options: options);
            }
            // update token and repeat
            // Lock to block the incoming request until the token updated
            dio.lock();
            dio.interceptors.responseLock.lock();
            dio.interceptors.errorLock.lock();

            final tokenDio = Dio(BaseOptions(
                baseUrl: options.baseUrl,
                connectTimeout: options.connectTimeout,
                receiveTimeout: options.receiveTimeout,
                headers: options.headers,
                responseType: options.responseType,
                method: 'POST'));

            tokenDio.interceptors
                .add(InterceptorsWrapper(onResponse: _onResponse));
            return tokenDio
                .request('/token/refresh/')
                .then((result) {
                  final newToken = result.data['token'].toString();
                  options.headers[HttpHeaders.authorizationHeader] =
                      'JWT $newToken';
                  providerInterface.onGotToken(newToken);
                }, onError: (error) {
                  if (error is DioError) {
                    throw _failure(error);
                  }
                })
                .whenComplete(_unLockCurrentDio)
                .then((e) {
                  //repeat
                  print('[API Provider]: Retry with path ${options.path}');
                  return dio.request(options.path, options: options);
                });
          }

        case CHErrorEnum.invalidToken:
        case CHErrorEnum.nullToken:
        case CHErrorEnum.refreshTokenFailed:
          providerInterface.onLogout();
          break;

        default:
          break;
      }
      return e; // Return this cherror
    }
    // Convert to cherror
    return _failure(e);
  };

  static Error _failure(DioError e) {
    print('[API Provider]: Unexpect Error Occurred, `${e.message}`');
    if (e is DioError &&
        e.response != null &&
        e.response.headers.contentType.value == ContentType.html.value) {
      final responseString = e.response.data.toString();
      final regExceptionValue = RegExp(
          r'<\s*th>Exception Value:<\s*\/\s*th>\s*<td><pre>(.*?)<\s*\/\s*pre><\/td>');
      final regExceptionType =
          RegExp(r'<\s*th>Exception Type:<\s*\/\s*th>\s*<td>(.*?)<\/td>');
      final matchesValue = regExceptionValue.firstMatch(responseString);
      final matchesType = regExceptionType.firstMatch(responseString);
      return CHError(
          message:
              'Service Error, code: ${e.response.statusCode}, ${matchesType?.group(1)}: ${matchesValue?.group(1)}',
          statusCode: 0x999999);
    }
    // final tmpError = e.toString();
    //   return CHError(
    //       codeString: 'unexpected error',
    //       statusCode: 0x999998,
    //       message: tmpError);
    return CHError.fromDioError(e);
  }

  static void _unLockCurrentDio() {
    dio.unlock();
    dio.interceptors.responseLock.unlock();
    dio.interceptors.errorLock.unlock();
  }

  static void clearCache() {
    _cache.clear();
  }
}

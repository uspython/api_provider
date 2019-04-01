/*
 * @Author: jeffzhao
 * @Date: 2019-03-19 15:19:51
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-04-01 17:06:39
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:io';

import 'package:api_datastore/api_datastore.dart'
    show ApiSettings, dio;
import 'package:dio/dio.dart'
    show
        DioError,
        Interceptor,
        InterceptorsWrapper,
        RequestOptions,
        Response,
        Dio,
        BaseOptions;
import 'package:built_value/serializer.dart';
import './api_provider_interface.dart';
import './cherror.dart';

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
    print('=============> confign initialize');
    print('=============> token from device');
    print('=============> :$token');

    final info = userInfo;
    ApiSettings().baseUrl =
        'https://${isDebug() ? 'api-qa' : 'api'}.city-home.cn';
    ApiSettings().connectTimeout = 120 * 1000;
    ApiSettings().receiveTimeout = 120 * 1000;
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
    print(
        'default request interceptor send request：path:${options.path}，baseURL:${options.baseUrl}');
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

    if (options.path == '/accounts/login/' ||
        options.path == '/accounts/api_token_refresh/') {
      options.headers.remove(HttpHeaders.authorizationHeader);
    }
  };

  static final ResponseCallbackType _onResponse = (Response resp) {
    print('=========> Default Response Interceptor');
    if (resp.statusCode == HttpStatus.ok) {
      final json = (resp.data as Map<String, dynamic>) ?? {};
      if (json.containsKey('status') && (json['status'] as int) != 0) {
        throw CHError.fromJson(json);
      } else if (json.containsKey('data')) {
        return _success((json['data'] as Map<String, dynamic>) ?? {}, resp);
      } else {
        return _success(json, resp);
      }
    }
    return resp.data;
  };

  static Map<String, dynamic> _success(
      Map<String, dynamic> json, Response resp) {
    switch (resp.request.path) {
      case '/accounts/login/':
        providerInterface.onGotToken(json['token'].toString());
        break;
      default:
    }
    return json;
  }

  final ErrorCallbackType _onError = (DioError e) {
    final chError = e as CHError;
    if (chError != null) {
      switch (chError.statusCode.toString()) {
        case CHErrorEnum.tokenExpired: {
          /// Refresh Token
          // return _refreshToken(chError);
          print('=========> refresh token');
          final options = chError.request;
          // If the token has been updated, repeat directly.
          if ('Bearer $token' != options.headers[HttpHeaders.authorizationHeader]) {
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
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
          ));

          tokenDio.interceptors.add(InterceptorsWrapper(onResponse: _onResponse));

          return tokenDio.request('/accounts/api_token_refresh/', queryParameters: {'token': token})
          .then((result) {
            final newToken = result.data['token'].toString();
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer $newToken';
            providerInterface.onGotToken(newToken);
          })
          .whenComplete(_unLockCurrentDio)
          .then((e) {
            //repeat
            return dio.request(options.path, options: options);
          });
        }
        default:
          break;
      }
    }
    return e;
  };

  static void _unLockCurrentDio() {
    dio.unlock();
    dio.interceptors.responseLock.unlock();
    dio.interceptors.errorLock.unlock();
  }
}

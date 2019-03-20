/*
 * @Author: jeffzhao
 * @Date: 2019-03-19 15:19:51
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-03-19 19:04:20
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:async';
import 'dart:io';

import 'package:api_datastore/api_datastore.dart'
    show dio, ApiSettings, ApiService;
import 'package:dio/dio.dart'
    show DioError, Interceptor, InterceptorsWrapper, RequestOptions, Response;
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

typedef RequestCallbackType = dynamic Function(RequestOptions);
typedef ResponseCallbackType = dynamic Function(Response<dynamic>);
typedef ErrorCallbackType = dynamic Function(DioError);
class ProviderService {
  static final ProviderService _s = ProviderService._internal();
  factory ProviderService() {
    _s._initializationFuture = _s._initializationFuture ?? _s._init();
    return _s;
  }
  ProviderService._internal();

  Future _initializationFuture;
  InterceptorsWrapper requestWrapper;
  // TODO: (jeff) 加入本地获取的token
  static String token = "";

  Future _init() async {
    print("=============> confign init");
    final Map<String, String> info = await userAgengInfo();
    ApiSettings().baseUrl =
        "https://${isDebug() ? 'api-qa' : 'api'}.city-home.cn";
    ApiSettings().connectTimeout = 10000;
    ApiSettings().receiveTimeout = 10000;
    ApiSettings().requestHeader = {
      HttpHeaders.userAgentHeader: info['ua'],
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.acceptEncodingHeader: 'gzip;q=1.0, compress;q=0.5',
      HttpHeaders.acceptLanguageHeader: '${info['locale']};q=1.0',
      HttpHeaders.connectionHeader: 'keep-alive',
    };
    ApiSettings().defaultInterceptors.add(_defaultWrapper());
  }

  Future get initializationDone => _initializationFuture;

  static bool isDebug() {
    return !bool.fromEnvironment('dart.vm.product');
  }

  static Future<Map<String, String>> userAgengInfo() async {
    final Completer<Map<String, String>> c = Completer();
    try {
      final deviceInfo = DeviceInfoPlugin();
      String device = "";
      String userAgent = "";
      String locale = "zh_CN";
      // TODO: Jeff: this UA only for testing
      if (Platform.isIOS) {
        final packageInfo = await PackageInfo.fromPlatform();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        device =
            "(${iosInfo.utsname.machine}; ${iosInfo.utsname.sysname})${iosInfo.systemVersion}; ";
        userAgent =
            'Qingbnb/${packageInfo.version}/${iosInfo.localizedModel} $device ${iosInfo.localizedModel}';
        locale = iosInfo.localizedModel;
      } else if (Platform.isAndroid || Platform.isFuchsia) {
        final packageInfo = await PackageInfo.fromPlatform();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        userAgent =
            "qsbnb/android/${packageInfo.version}/zh/ (${androidInfo.version})shamu (${androidInfo.model})";
      } else {
        final packageInfo = PackageInfo(appName: 'test', packageName: 'testP', version: '0.0.1', buildNumber: '23');
        userAgent = 'Qingbnbtest/${packageInfo.appName}/${packageInfo.version}/${packageInfo.packageName}';
      }
      c.complete({"ua": userAgent, "locale": locale});
    } catch (e) {
      print(e);
      c.completeError(e);
    }
    return c.future;
  }

  Interceptor _defaultWrapper() {
    final InterceptorsWrapper defaultRequestInterceptor = InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError
    );
    return defaultRequestInterceptor;
  }

  final RequestCallbackType _onRequest = (RequestOptions options) {
      print('send request：path:${options.path}，baseURL:${options.baseUrl}');
      if (token == null) {
        print("no token，request token firstly...");
        //lock the dio.
        dio.lock();
        return ApiService.get<Map<String, dynamic>>("/accounts/api_token_refresh/")
        .then((d) {
          options.headers["token"] = d.data['token'];
          //print("request token succeed, value: " + d.data['token']);
          print(
              'continue to perform request：path:${options.path}，baseURL:${options.path}');
          return options;
        }).whenComplete(() => dio.unlock()); // unlock the dio
      } else {
        options.headers["token"] = token;
        return options;
      }
    };

  final ResponseCallbackType _onResponse = (Response resp) => {

  };

  final ErrorCallbackType _onError = (DioError error) {
      // Assume 401 stands for token expired
      if (error.response?.statusCode == 401) {
        RequestOptions options = error.response.request;
        // If the token has been updated, repeat directly.
        if (token != options.headers["token"]) {
          options.headers["token"] = token;
          //repeat
          return dio.request(options.path, options: options);
        }
        // update token and repeat
        // Lock to block the incoming request until the token updated
        dio.lock();
        dio.interceptors.responseLock.lock();
        dio.interceptors.errorLock.lock();
        return ApiService.get<Map<String, dynamic>>("/accounts/api_token_refresh/").then((d) {
          //update token
          options.headers["token"] = token = d.data['token'].toString();
        }).whenComplete(() {
          dio.unlock();
          dio.interceptors.responseLock.unlock();
          dio.interceptors.errorLock.unlock();
        }).then((e) {
          //repeat
          return dio.request(options.path, options: options);
        });
      }
      return error;
    };
}



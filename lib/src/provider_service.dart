/*
 * @Author: jeffzhao
 * @Date: 2019-03-19 15:19:51
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-03-20 19:13:21
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:async';
import 'dart:io';

import 'package:api_datastore/api_datastore.dart'
    show ApiSettings;
import 'package:dio/dio.dart'
    show DioError, Interceptor, InterceptorsWrapper, RequestOptions, Response;
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import './cherror.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef RequestCallbackType = dynamic Function(RequestOptions);
typedef ResponseCallbackType = dynamic Function(Response<dynamic>);
typedef ErrorCallbackType = dynamic Function(DioError);

class TestShare {
  get(String key) {
    return "xxxx";
  }
  setString(String key, String value) {
    print('key: $key, value: $value');
  }
}
class ProviderService {
  static final ProviderService _s = ProviderService._internal();
  factory ProviderService() {
    _s._initializationFuture = _s._initializationFuture ?? _s._init();
    return _s;
  }
  ProviderService._internal();

  Future<void> _initializationFuture;
  Future<void> get initializationDone => _initializationFuture;
  String _token = "";
  // TODO: (jeff) this is for testing only
  static SharedPreferences _sharedPreferences;
  // static TestShare _sharedPreferences;



  Future<void> _init() async {
    print("=============> confign init");
    print("============= get token from device ==========");
    // TODO: (jeff) this is for testing only
    //get token
    _sharedPreferences = await SharedPreferences.getInstance();
    //_sharedPreferences = TestShare() ;
    _token = (_sharedPreferences.get("CHINVESTMENT_TOKEN") ?? "") as String;
    print("=============> token: $_token");

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
        userAgent = 'Qingbnb/${packageInfo.appName}/${packageInfo.version}/${packageInfo.packageName}';
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
      print('default request interceptor send request：path:${options.path}，baseURL:${options.baseUrl}');
    };

  final ResponseCallbackType _onResponse = (Response resp) {
    print("=========> Default Response Interceptor");
    /// Save the token if needed
    final _success = (Map<String, dynamic> json, Response resp) {
      switch (resp.request.path) {
        case '/accounts/login/':
          _sharedPreferences.setString('CHINVESTMENT_TOKEN', json['token'].toString());
          break;
        default:
      }
    };

    if (resp.statusCode == HttpStatus.ok) {
      final json = (resp.data as Map<String, dynamic>) ?? {};
        if ((json["status"] as int) != 0) {
          throw CHError.fromJson(json);
        } else if (json.keys.contains("data")) {
          _success((json["data"] as Map<String, dynamic>) ?? {}, resp);
          return json["data"] as Map<String, dynamic>;
        } else {
          _success(json, resp);
          return json;
        }
    }
    return resp.data;
  };

  final ErrorCallbackType _onError = (DioError e) {
    return e;
    };
}



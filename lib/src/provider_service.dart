/*
 * @Author: jeffzhao
 * @Date: 2019-03-19 15:19:51
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-04-01 12:43:17
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
import 'package:built_value/serializer.dart';
import './cherror.dart';


typedef RequestCallbackType = dynamic Function(RequestOptions);
typedef ResponseCallbackType = dynamic Function(Response<dynamic>);
typedef ErrorCallbackType = dynamic Function(DioError);

class TestShare {

  String getString(String key) {
    return 'xxxx';
  }
  void setString(String key, String value) {
    print('key: $key, value: $value');
  }
}
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

  static void Function(String) get onGotToken => _onGotToken;
  static void Function(String) _onGotToken;
  static void Function() get onLogout => _onLogout;
  static void Function() _onLogout;

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

  void setOnGotToken(void Function(String) block) {
    _onGotToken = block;
  }

  void setOnLogout(void Function() block) {
    _onLogout = block;
  }

  dynamic _init() {
    print('=============> confign initialize');
    print('============= token from device ==========');
    print('=============> :$token');

    final info = userInfo;
    ApiSettings().baseUrl = 'https://${isDebug() ? 'api-qa' : 'api'}.city-home.cn';
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

  static Map<String, dynamic> _success(Map<String, dynamic> json, Response resp) {
      switch (resp.request.path) {
        case '/accounts/login/':
          onGotToken(json['token'].toString());
          break;
        default:
      }
      return json;
  }

  final ErrorCallbackType _onError = (DioError e) {
    return e;
  };
}

/*
 * @Author: jeffzhao
 * @Date: 2019-03-24 23:07:45
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-04-02 16:32:23
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:async';

import 'package:api_datastore/api_datastore.dart'
    show ApiService, CallbackOptions, dio;
import 'package:built_value/serializer.dart';
import './provider_service.dart';

class ApiProvider {
  /// fetch api using GET Method with [path],
  /// [params] are parameters,
  /// if you need your own request interceptor
  /// using [CallbackOptions] [callbacks],
  /// when [needCache] is ture, the response will be cached in ram
  static Future<T> fetch<T>(String path,
      {Map<String, dynamic> params,
      CallbackOptions callbacks,
      bool needCache = false}) async {
    final completer = Completer<T>();
    try {
      final ret = await ApiService.get(path,
          params: params, callbacks: callbacks, needCached: needCache);
      completer.complete(_serialized<T>(ret.data));
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  /// Fetch api using POST Method with [path],
  /// [params] are parameters,
  /// if you need your own request interceptor
  /// using [CallbackOptions] [callbacks]
  static Future<T> fetchPost<T>(String path,
      {Map<String, dynamic> params, CallbackOptions callbacks}) async {
    final completer = Completer<T>();
    try {
      final ret =
          await ApiService.post(path, params: params, callbacks: callbacks);
      completer.complete(_serialized<T>(ret.data));
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  static T _serialized<T>(dynamic data) {
    print('[API Provider]: Serializing to ${data.runtimeType.toString()}');
    var r = data;
    if (T != dynamic) {
      r = ProviderService.jsonSerializers
          .deserialize(data, specifiedType: FullType(T));
    }
    return r as T;
  }

  /// fetch api using GET Method with [path],
  /// [params] are parameters,
  /// if you need your own request interceptor
  /// using [CallbackOptions] [callbacks],
  /// when [needCache] is ture, the response will be cached in ram
  static Future<T> fetchFake<T>(String path,
      {Map<String, dynamic> params,
      CallbackOptions callbacks,
      bool needCache = false}) async {
    final completer = Completer<T>();
    try {
      final ret = await dio.get(path, queryParameters: params);
      completer.complete(_serialized<T>(ret.data));
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  /// Fetch api using POST Method with [path],
  /// [params] are parameters,
  /// if you need your own request interceptor
  /// using [CallbackOptions] [callbacks]
  static Future<T> fetchPostFake<T>(String path,
      {Map<String, dynamic> params, CallbackOptions callbacks}) async {
    final completer = Completer<T>();
    try {
      final ret = await dio.post(path, queryParameters: params);
      completer.complete(_serialized<T>(ret.data));
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}

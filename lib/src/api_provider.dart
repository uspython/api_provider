/*
 * @Author: jeffzhao
 * @Date: 2019-03-24 23:07:45
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-04-02 16:32:23
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:async';

import 'package:api_datastore/api_datastore.dart';
import 'package:built_value/serializer.dart';
import './provider_service.dart';

class ApiProvider {
  static Future<T> fetch<T>(String path,
      {Map<String, dynamic> params,
      CallbackOptions callbacks,
      bool needCache = false}) async {
    final completer = Completer<T>();
    try {
      final ret = await ApiService.get(path,
          params: params, callbacks: callbacks, needCached: needCache);
      completer.complete(_success<T>(ret.data));
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  static Future<T> fetchPost<T>(String path,
      {Map<String, dynamic> params, CallbackOptions callbacks}) async {
    final completer = Completer<T>();
    try {
      final ret =
          await ApiService.post(path, params: params, callbacks: callbacks);
      completer.complete(_success<T>(ret.data));
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  static T _success<T>(dynamic data) {
    var r = data;
    if (T != dynamic) {
      r = ProviderService.jsonSerializers
          .deserialize(data, specifiedType: FullType(T));
    }
    return r as T;
  }
}

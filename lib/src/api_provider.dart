/*
 * @Author: jeffzhao
 * @Date: 2019-03-24 23:07:45
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-03-25 16:48:13
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:async';

import 'package:api_datastore/api_datastore.dart';
import 'package:built_value/serializer.dart';
import './provider_service.dart';

class ApiProvider {
  static Future<T> fetch<T>(String path, {Map<String, dynamic> params, CallbackOptions callbacks}) async {
    final completer = Completer<T>();
    try {
      final ret = await ApiService.get(path, params: params, callbacks: callbacks);
      var r = ret.data;
      if (T != dynamic) {
        r = ProviderService.jsonSerializers.deserialize(ret.data, specifiedType: FullType(T));
      }
      completer.complete(r as T);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}

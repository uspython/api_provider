/*
 * @Author: jeffzhao
 * @Date: 2019-03-24 23:07:45
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-03-25 16:48:13
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'dart:async';

import 'package:api_datastore/api_datastore.dart';
import 'api_json_converter.dart';
import 'dart:';

class JsonConvertable {
  final String genericPlaceHolder;
  JsonConvertable({this.genericPlaceHolder});

  factory JsonConvertable.fromJson(Map<String, dynamic> json) => JsonConvertable(genericPlaceHolder: json['_empty'] as String);
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }
  JsonConvertable fromMap(Map<String, dynamic> json) => JsonConvertable(genericPlaceHolder: json['_empty'] as String);
}

class ApiProvider {
  static Future<T> fetchGet<T>(String path, {Map<String, dynamic> params, CallbackOptions callbacks}) async {
    final completer = Completer<T>();
    try {
      final ret = await ApiService.get(path, params: params, callbacks: callbacks);

      final r = (T as JsonConvertable).fromMap(ret.data as Map<String, dynamic>);
      completer.complete(r as T);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}

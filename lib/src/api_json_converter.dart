/*
 * @Author: jeffzhao
 * @Date: 2019-03-22 15:14:09
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-03-24 23:40:46
 * Copyright Zhaojianfei. All rights reserved.
 */
import 'package:json_annotation/json_annotation.dart' show JsonConverter;

class ApiJsonConverter<T> implements JsonConverter<T, Object> {
  const ApiJsonConverter();

  @override
  T fromJson(Object json) {
    // This will only work if `json` is a native JSON type:
    //   num, String, bool, null, etc
    // *and* is assignable to `T`.
    return json as T;
  }

  @override
  Object toJson(T object) {
    // This will only work if `object` is a native JSON type:
    //   num, String, bool, null, etc
    // Or if it has a `toJson()` function`.
    return object;
  }
}

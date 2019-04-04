/*
 * @Author: jeffzhao
 * @Date: 2019-03-20 15:31:17
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-04-01 16:13:41
 * Copyright Zhaojianfei. All rights reserved.
 */

import 'package:dio/dio.dart';

class CHError extends DioError {
  CHError({this.message, this.statusCode, this.codeString}) : super() {
    super.message = message;
  }

  CHError.fromJson(Map<String, dynamic> json)
      : message = json['reason'].toString(),
        codeString = json['code_string'].toString(),
        statusCode = int.parse(json['code_number'].toString()) {
    super.message = message;
  }

  @override
  final String message;

  final int statusCode;

  final String codeString;
}

class CHErrorEnum {
  static const String serviceFailure = '10066329'; // 0x999999
  static const String tokenExpired = '10005';
  static const String invalidToken = '10011';
  static const String permissionDenied = '10004';
  static const String refreshTokenFailed = '10010';
}

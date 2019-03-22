/*
 * @Author: jeffzhao
 * @Date: 2019-03-20 15:31:17
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-03-22 17:46:01
 * Copyright Zhaojianfei. All rights reserved.
 */

import 'package:dio/dio.dart';

class CHError extends DioError {
  CHError({ this.message, this.statusCode }): super() {
    super.message = message;
  }

  CHError.fromJson(Map<String, dynamic> json)
      : message = json['message'].toString(),
        statusCode = int.parse(json['status'].toString()) {
          super.message = message;
        }

  @override
  final String message;

  final int statusCode;
}

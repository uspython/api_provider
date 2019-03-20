/*
 * @Author: jeffzhao
 * @Date: 2019-03-20 15:31:17
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-03-20 17:49:44
 * Copyright Zhaojianfei. All rights reserved.
 */

import 'package:dio/dio.dart';

class CHError extends DioError {
  CHError({ this.message, this.statusCode }): super() {
    super.message = this.message;
  }

  CHError.fromJson(Map<String, dynamic> json)
      : this.message = json["message"].toString(),
        this.statusCode = int.parse(json["status"].toString()) {
          super.message = this.message;
        }

  final String message;
  final int statusCode;
}

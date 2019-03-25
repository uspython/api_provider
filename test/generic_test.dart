import 'dart:convert';
import 'dart:io';

import 'package:api_provider/src/api_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:api_datastore/api_datastore.dart';
import 'package:dio/dio.dart';
import './example.dart';

void main() {
  ApiSettings().baseUrl = 'https://jsonplaceholder.typicode.com';
  ApiSettings().connectTimeout = 60 * 1000;
  ApiSettings().receiveTimeout = 60 * 1000;
  ApiSettings().requestHeader = {
    HttpHeaders.userAgentHeader:
        'Qingbnb/0.1.6/en (iPhone10,6; iOS)12.1; zh_CN',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.acceptEncodingHeader: 'gzip;q=1.0, compress;q=0.5',
    HttpHeaders.acceptLanguageHeader: 'zh_CN;q=1.0',
    HttpHeaders.connectionHeader: 'keep-alive',
  };
  // ApiSettings()
  //     .defaultInterceptors
  //     .add(InterceptorsWrapper(onResponse: (Response resp) {
  //   print('===============> another interceptor');
  //   print(resp.data);
  // }));

 test('test fetch User', () async {
    final ret2 = await ApiProvider.fetchGet<User>('/users/1');
    //final ret = await ApiService.get<User>('/users/1');
    print(ret2);
  });
}

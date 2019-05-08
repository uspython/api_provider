/*
 * @Author: jeffzhao
 * @Date: 2019-04-01 12:26:23
 * @Last Modified by: jeffzhao
 * @Last Modified time: 2019-04-01 17:08:50
 * Copyright Zhaojianfei. All rights reserved.
 */

import 'dart:convert';

import 'package:api_provider/src/cherror.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:api_provider/api_provider.dart';
import 'package:api_datastore/api_datastore.dart';
import 'package:dio/dio.dart';
import 'package:api_provider/src/api_provider_interface.dart';

final token =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6Ilx1NTkwZlx1NTFlMSIsInVzZXJfaWQiOjQ3NCwib3JpZ19pYXQiOjE1NTU2NjYxNzQsImV4cCI6MTU1NTgzODk3NCwiZW1haWwiOiIxMzI1NDY3NTg3NjVAcXEuY29tIn0.DLj5bx6ltcvq1g662jod0Hti9gBxwDYRrHl9q5orW64';
//final token = '2808555322_05ffcdba677745ff98e675f983eb06fc';
// final token =
//     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJvcmlnX2lhdCI6MTU1NTg0MDM4NywidXNlcl9pZCI6NDc0LCJ1c2VybmFtZSI6Ilx1NTkwZlx1NTFlMSIsImVtYWlsIjoiMTExMzI1NDY3NTg3NjVAcXEuY29tIiwiZXhwIjoxNTU2MDEzMTg3fQ.L1Xj3db6K6fDEjjFdIachRC_WTg1uBDK1KVjGryzOSA';
final info = {
  'ua': 'chinvestment/0.0.1/en (iPhone10,6; iOS)12.1; en_US',
  'locale': 'zh_CN'
};
//final onGotToken = (String atoken) => print('got token from api $atoken');
//final onLogout = () => print('log out');

class TestInterface extends ApiProviderInterface {
  @override
  final onGotToken = (String atoken) => print('got token from api $atoken');
  @override
  final onLogout = () => print('log out');
  @override
  final onLogin = () => print('log in');
}

final testInterface = TestInterface();

void main() {
  final providerService = ProviderService()
    ..setToken(token)
    ..setUserInfo(info)
    ..setProviderInterface(testInterface)
    ..initializationDone();
  print('init done');

  test('interractor with wrong url error', () async {
    try {
      final test = await ApiService.get('/error_url/');
      print(test);
    } on DioError catch (e) {
      expect(e.message.contains('404'), true);
    } on Error catch (e) {
      print(e);
    }
  });

  test('ProviderService should be inited once only', () async {
    final anotherService = ProviderService();
    expect(providerService, anotherService);
    expect(
        providerService.initializationDone, anotherService.initializationDone);
  });

  test('test token saving', () async {
    try {
      final ret = await ApiProvider.fetchPost('/token/obtain/',
          params: {'username': '15010331462', 'password': '123456'});

      print(jsonEncode(ret));
      expect(jsonEncode(ret['token'].toString()), isNotNull);
    } on CHError catch (e) {
      expect(e.statusCode, 10002);
      print(e.message);
    } on DioError catch (e) {
      print(e.response);
    }
  });

  test('test wrong password', () async {
    try {
      final ret = await ApiProvider.fetchPost('/token/obtain/',
          params: {'username': '15010331462', 'password': '1234561111'});

      print(jsonEncode(ret.data['error']));
    } on CHError catch (e) {
      print(e);
      expect(e.statusCode, 10004);
    }
  });

  test('force refresh token', () async {
    try {
      final _ = await ApiService.post('/token/refresh/');
    } on CHError catch (e) {
      expect(e.statusCode, int.parse(CHErrorEnum.nullToken));
      expect(e.message, '请求头没有带Token');
    } on DioError catch (e) {
      expect(e.type, DioErrorType.RESPONSE);
    }
  });

  test('token expired, refresh token', () async {
    try {
      final ret = await ApiProvider.fetch('/order/month/summary/');
      print(jsonEncode(ret));
      expect(double.parse(ret['calc_total_income'].toString()), isPositive);
    } on CHError catch (e) {
      print(e);
      expect(e.statusCode.toString(), CHErrorEnum.refreshTokenFailed);
    } on DioError catch (e) {
      print(e);
    }
  }, timeout: Timeout(Duration(seconds: 120)));

  test('api 404', () async {
    try {
      final ret = await ApiProvider.fetch('/order/month/summary111/');
      print(jsonEncode(ret));
    } on CHError catch (e) {
      print(e);
      expect(e.statusCode, 0x999999);
    }
  });

  test('fake logout', () async {
    try {
      final ret = await ApiProvider.fetch('/logout/');
      print(jsonEncode(ret));
    } on CHError catch (e) {
      print(e.response);
    } on DioError catch (e) {
      print(e.response);
    }
  });

  test('regex error', () {
    final regExp = RegExp(
        r'<\s*th>Exception Value:<\s*\/\s*th>\s*<td><pre>(.*?)<\s*\/\s*pre><\/td>');
    final exp = regExp;
    final str =
        '''https://api-investor-qa.city-home.cn/order/month/summary/</td>
	    </tr>
	    <tr>
	      <th>Django Version:</th>
	      <td>2.0</td>
	    </tr>
	    <tr>
	      <th>Exception Type:</th>
	      <td>DecodeError</td>
	    </tr>
	    <tr>
	      <th>Exception Value:</th>
	      <td><pre>Not enough segments</pre></td>
	    </tr>
	    <tr>''';
    final matches = exp.allMatches(str);
    for (var item in matches) {
      print(item.group(1));
    }
  });
}

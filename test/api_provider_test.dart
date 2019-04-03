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

final token = '2808555322_d953c3fb7d0e4b72b81a4f31a8b2c7c6';
// final token = '2808555322_05ffcdba677745ff98e675f983eb06fc';
final info = {
  'ua': 'Qingbnb/0.0.1/en (iPhone10,6; iOS)12.1; en_US',
  'locale': 'zh_CN'
};
//final onGotToken = (String atoken) => print('got token from api $atoken');
//final onLogout = () => print('log out');

class TestInterface extends ApiProviderInterface {
  @override
  final onGotToken = (String atoken) => print('got token from api $atoken');
  @override
  final onLogout = () => print('log out');
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
      expect(e.type, DioErrorType.RESPONSE);
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

  test('interractor with api status code error', () async {
    try {
      final _ = await ApiService.post('/accounts/api_token_refresh/',
          params: {'token': 'xxx'});
    } on CHError catch (e) {
      expect(e.statusCode, 10010);
      expect(e.message, '刷新时间过期');
    } on DioError catch (e) {
      expect(e.type, DioErrorType.RESPONSE);
    }
  });

  test('interractor with api status code error 2', () async {
    try {
      final _ = await ApiService.get('/accounts/api_token_refresh/',
          params: {'token': 'xxx'});
    } on CHError catch (e) {
      expect(e.statusCode, 10010);
      expect(e.message, '刷新时间过期');
    } on DioError catch (e) {
      expect(e.type, DioErrorType.RESPONSE);
    }
  });

  test('test token saving', () async {
    try {
      final ret = await ApiService.post('/accounts/login/',
          params: {'username': 'jiangguangbin', 'password': '123456'});

      print(jsonEncode(ret.data['token']));
    } on CHError catch (e) {
      expect(e.statusCode, 10010);
      expect(e.message, '刷新时间过期');
    } on DioError catch (e) {
      print(e.response);
    }
  });

  test('token expired, refresh token failed', () async {
    try {
      final ret = await ApiProvider.fetch('/rooms/state/');
      print(jsonEncode(ret));
    } on CHError catch (e) {
      expect(e.statusCode.toString(), CHErrorEnum.refreshTokenFailed);
    } on DioError catch (e) {
      print(e.response);
    }
  });
}

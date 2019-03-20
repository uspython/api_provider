import 'package:api_provider/src/cherror.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:api_provider/api_provider.dart';
import 'package:api_datastore/api_datastore.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  ProviderService providerService;
  setUp(() {
    SharedPreferences.setMockInitialValues({
      "CHINVESTMENT_TOKEN": "",
    });
    providerService = ProviderService();

  });
  group("Api Privider Service", () {
    test('init', () async {
      await providerService.initializationDone;
      print("init done");
    });

    test('interractor with wrong url error', () async {
      try {
        final test = await ApiService.get('/error_url/');
        print(test);
      } on DioError catch (e) {
        expect(e.type, DioErrorType.RESPONSE);
      }
    });

    test('ProviderService should be inited once only', () async {
      final anotherService = ProviderService();
      expect(providerService, anotherService);
      expect(providerService.initializationDone,
          anotherService.initializationDone);
    });

    test('interractor with api status code error', () async {
      try {
        final _ = await ApiService.get('/accounts/api_token_refresh/',
            params: {"token": "xxx"});
      } on CHError catch (e) {
        expect(e.statusCode, 10010);
        expect(e.message, '刷新时间过期');
      }
    });

    test('interractor with api status code error 2', () async {
      try {
        final _ = await ApiService.get('/accounts/api_token_refresh/',
            params: {"token": "xxx"});
      } on CHError catch (e) {
        expect(e.statusCode, 10010);
        expect(e.message, '刷新时间过期');
      }
    });

    test('test token saving', () async {
      try {
        final _ = await ApiService.post('/accounts/login/',
            params: {"username": "jiangguangbin", "password": "123456"});
      } on CHError catch (e) {
        expect(e.statusCode, 10010);
        expect(e.message, '刷新时间过期');
      } on DioError catch (e) {
        print(e.response);
      }
    });
  });
}

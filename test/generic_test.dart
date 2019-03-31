import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:api_datastore/api_datastore.dart';
import 'package:api_provider/api_provider.dart';
import 'package:built_value/standard_json_plugin.dart';
import './serializer.dart';
import './user_modal.dart';

final testS = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

void main() {
  final _ = ProviderService();
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
  ProviderService.jsonSerializers = testS;

  test('test await initialization', () async {
    // await providerService.initializationDone;
  });

  test('test', () async {
    final ret = await ApiProvider.fetch<UserModal>('/users/1');
    print(ret);
  });
}

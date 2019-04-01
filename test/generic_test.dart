/*
 * @Author: jeffzhao
 * @Date: 2019-04-01 12:26:12
 * @Last Modified by:   jeffzhao
 * @Last Modified time: 2019-04-01 12:26:12
 * Copyright Zhaojianfei. All rights reserved.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:api_datastore/api_datastore.dart';
import 'package:api_provider/api_provider.dart';
import 'package:built_value/standard_json_plugin.dart';
import './serializer.dart';
import './user_modal.dart';

final testS = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
final token = '';
final info = {'ua': 'Qingbnb/0.0.1/en (iPhone10,6; iOS)12.1; en_US', 'locale': 'zh_CN'};

void main() {
  final _ = ProviderService()
    ..setToken(token)
    ..setUserInfo(info)
    ..setSerializers(testS)
    ..initializationDone();
     print('init done');
  ApiSettings().baseUrl = 'https://jsonplaceholder.typicode.com';
  //ProviderService.jsonSerializers = testS;

  test('test UserModal', () async {
    final ret = await ApiProvider.fetch<UserModal>('/users/1');
    print(ret);
  });
}

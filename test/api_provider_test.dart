import 'package:flutter_test/flutter_test.dart';
import 'package:api_provider/api_provider.dart';
import 'package:package_info/package_info.dart';

void main() {
  setUp(() {
  });
  test('provider service init', () async {
    final providerService = ProviderService();
    await providerService.initializationDone;
    print("done");
    //expect(providerService.init(), 3);
  });
}

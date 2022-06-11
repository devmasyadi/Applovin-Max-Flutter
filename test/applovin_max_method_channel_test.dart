import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applovin_max/applovin_max_method_channel.dart';

void main() {
  MethodChannelApplovinMax platform = MethodChannelApplovinMax();
  const MethodChannel channel = MethodChannel('applovin_max');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

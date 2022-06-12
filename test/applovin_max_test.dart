import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:applovin_max/applovin_max_platform_interface.dart';
import 'package:applovin_max/applovin_max_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockApplovinMaxPlatform
    with MockPlatformInterfaceMixin
    implements ApplovinMaxPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> setAdUnit(String? bannerId, String? interstitialId,
      String? nativeId, String? rewardsAdsId) {
    throw UnimplementedError();
  }

  void main() {
    final ApplovinMaxPlatform initialPlatform = ApplovinMaxPlatform.instance;

    test('$MethodChannelApplovinMax is the default instance', () {
      expect(initialPlatform, isInstanceOf<MethodChannelApplovinMax>());
    });

    test('getPlatformVersion', () async {
      ApplovinMax applovinMaxPlugin = ApplovinMax();
      MockApplovinMaxPlatform fakePlatform = MockApplovinMaxPlatform();
      ApplovinMaxPlatform.instance = fakePlatform;

      expect(await applovinMaxPlugin.getPlatformVersion(), '42');
    });
  }

  @override
  Future<void> createInterstitial({AppLovinListener? appLovinListener}) {
    throw UnimplementedError();
  }

  @override
  Future<void> createRewards({AppLovinListener? appLovinListener}) {
    throw UnimplementedError();
  }

  @override
  Future<void> initSdk(AppLovinInitListener? appLovinInitListener) {
    throw UnimplementedError();
  }

  @override
  Future<void> showInterstitial() {
    throw UnimplementedError();
  }

  @override
  Future<void> showRewards() {
    throw UnimplementedError();
  }

  @override
  Future<void> handleMethod(MethodCall call, AppLovinListener listener) {
    throw UnimplementedError();
  }
}

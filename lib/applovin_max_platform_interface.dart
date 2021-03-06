import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'applovin_max_method_channel.dart';

abstract class ApplovinMaxPlatform extends PlatformInterface {
  /// Constructs a ApplovinMaxPlatform.
  ApplovinMaxPlatform() : super(token: _token);

  static final Object _token = Object();

  static ApplovinMaxPlatform _instance = MethodChannelApplovinMax();

  /// The default instance of [ApplovinMaxPlatform] to use.
  ///
  /// Defaults to [MethodChannelApplovinMax].
  static ApplovinMaxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ApplovinMaxPlatform] when
  /// they register themselves.
  static set instance(ApplovinMaxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initSdk(AppLovinInitListener? appLovinInitListener) async {
    throw UnimplementedError('initSdk() has not been implemented.');
  }

  Future<void> setAdUnit(String? bannerId, String? interstitialId,
      String? nativeId, String? rewardsAdsId) async {
    throw UnimplementedError('setAdUnit() has not been implemented.');
  }

  Future<void> createInterstitial({AppLovinListener? appLovinListener}) async {
    throw UnimplementedError('createInterstitial() has not been implemented.');
  }

  Future<void> showInterstitial() async {
    throw UnimplementedError('showInterstitial() has not been implemented.');
  }

  Future<void> createRewards({AppLovinListener? appLovinListener}) async {
    throw UnimplementedError('createRewards() has not been implemented.');
  }

  Future<void> showRewards() async {
    throw UnimplementedError('showRewards() has not been implemented.');
  }

  Future<void> handleMethod(
      MethodCall call, AppLovinListener listener) async {
    throw UnimplementedError('handleMethod() has not been implemented.');
  }
}

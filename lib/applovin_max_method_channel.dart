import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'applovin_max_platform_interface.dart';

enum AppLovinAdListener {
  adLoaded,
  adLoadFailed,
  adDisplayed,
  adHidden,
  adClicked,
  onAdDisplayFailed,
  onRewardedVideoStarted,
  onRewardedVideoCompleted,
  onUserRewarded
}

typedef AppLovinListener = Function(AppLovinAdListener? listener);
typedef AppLovinInitListener = Function(bool isInitialized);
final Map<String, AppLovinAdListener> appLovinAdListener =
    <String, AppLovinAdListener>{
  'onAdLoaded': AppLovinAdListener.adLoaded,
  'onAdLoadFailed': AppLovinAdListener.adLoadFailed,
  'onAdDisplayed': AppLovinAdListener.adDisplayed,
  'onAdHidden': AppLovinAdListener.adHidden,
  'onAdClicked': AppLovinAdListener.adClicked,
  'onAdFailedToDisplay': AppLovinAdListener.onAdDisplayFailed,
  'onRewardedVideoStarted': AppLovinAdListener.onRewardedVideoStarted,
  'onRewardedVideoCompleted': AppLovinAdListener.onRewardedVideoCompleted,
  'onUserRewarded': AppLovinAdListener.onUserRewarded,
};

/// An implementation of [ApplovinMaxPlatform] that uses method channels.
class MethodChannelApplovinMax extends ApplovinMaxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('applovin_max');

  @override
  Future<String?> getPlatformVersion() async {
    return await methodChannel.invokeMethod<String>('initSdk');
  }

  @override
  Future<void> setAdUnit(String? bannerId, String? interstitialId,
      String? nativeId, String? rewardsAdsId) async {
    await methodChannel.invokeMethod<void>(
      'setAdUnit',
      <String, dynamic>{
        "bannerId": bannerId,
        "interstitialId": interstitialId,
        "nativeId": nativeId,
        "rewardsAdsId": rewardsAdsId
      },
    );
  }

  @override
  Future<void> initSdk(AppLovinInitListener? appLovinInitListener) async {
    if (appLovinInitListener != null) {
      methodChannel.setMethodCallHandler((MethodCall call) async {
        return appLovinInitListener(call.arguments["isInitialized"]);
      });
    }
    await methodChannel.invokeMethod<String>('initSdk');
  }

  @override
  Future<void> showInterstitial(AppLovinListener? appLovinListener) async {
    if (appLovinListener != null) {
      methodChannel.setMethodCallHandler(
          (MethodCall call) => handleMethod(call, appLovinListener));
    }
    await methodChannel.invokeMethod<String>('showInterstitial');
  }

  static Future<void> handleInitListener(
      MethodCall call, AppLovinInitListener listener) async {
    listener(call.arguments["isInitialized"]);
  }

  static Future<void> handleMethod(
      MethodCall call, AppLovinListener listener) async {
    listener(appLovinAdListener[call.method]);
  }
}

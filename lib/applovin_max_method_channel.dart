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
  onUserRewarded,
  onNativeAdLoaded,
  onNativeAdLoadFailed
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
  'onNativeAdLoaded': AppLovinAdListener.onNativeAdLoaded,
  'onNativeAdLoadFailed': AppLovinAdListener.onNativeAdLoadFailed,
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
  Future<void> initSdk(AppLovinInitListener? appLovinInitListener) async {
    if (appLovinInitListener != null) {
      methodChannel.setMethodCallHandler((MethodCall call) async {
        return appLovinInitListener(call.arguments["isInitialized"]);
      });
    }
    await methodChannel.invokeMethod<String>('initSdk');
  }

  @override
  Future<void> setAdUnit(String? bannerId, String? interstitialId,
      String? nativeId, String? rewardsAdsId) async {
    await methodChannel.invokeMethod<void>(
      'setAdUnit',
      {
        "bannerId": bannerId,
        "interstitialId": interstitialId,
        "nativeId": nativeId,
        "rewardsAdsId": rewardsAdsId
      },
    );
  }

  @override
  Future<void> createInterstitial(AppLovinListener? appLovinListener) async {
    if (appLovinListener != null) {
      methodChannel.setMethodCallHandler(
          (MethodCall call) => handleMethod(call, appLovinListener));
    }
    await methodChannel.invokeMethod<String>('createInterstitial');
  }

  @override
  Future<void> showInterstitial() async {
    await methodChannel.invokeMethod<String>('showInterstitial');
  }

  @override
  Future<void> createRewards(AppLovinListener? appLovinListener) async {
    if (appLovinListener != null) {
      methodChannel.setMethodCallHandler(
          (MethodCall call) => handleMethod(call, appLovinListener));
    }
    await methodChannel.invokeMethod<String>('createRewards');
  }

  @override
  Future<void> showRewards() async {
    await methodChannel.invokeMethod<String>('showRewards');
  }

  @override
  Future<void> handleMethod(
      MethodCall call, AppLovinListener listener) async {
    listener(appLovinAdListener[call.method]);
  }
}

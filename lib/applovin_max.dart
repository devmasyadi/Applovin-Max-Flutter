import 'package:applovin_max/applovin_max_method_channel.dart';

import 'applovin_max_platform_interface.dart';

class ApplovinMax {
  Future<String?> getPlatformVersion() {
    return ApplovinMaxPlatform.instance.getPlatformVersion();
  }

  Future<void> initSdk({AppLovinInitListener? appLovinInitListener}) {
    return ApplovinMaxPlatform.instance.initSdk(appLovinInitListener);
  }

  Future<void> setAdUnit(
      {String? bannerId,
      String? interstitialId,
      String? nativeId,
      String? rewardsAdsId}) async {
    return ApplovinMaxPlatform.instance
        .setAdUnit(bannerId, interstitialId, nativeId, rewardsAdsId);
  }

  Future<void> createInterstitial({AppLovinListener? appLovinListener}) async {
    return ApplovinMaxPlatform.instance.createInterstitial(appLovinListener);
  }

  Future<void> showInterstitial() async {
    return ApplovinMaxPlatform.instance.showInterstitial();
  }

  Future<void> createRewards({AppLovinListener? appLovinListener}) async {
    return ApplovinMaxPlatform.instance.createRewards(appLovinListener);
  }

  Future<void> showRewards() async {
    return ApplovinMaxPlatform.instance.showRewards();
  }
}

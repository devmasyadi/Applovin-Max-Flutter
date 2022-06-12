import 'dart:io';

import 'package:applovin_max/applovin_max_method_channel.dart';
import 'package:applovin_max/applovin_max_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BannerAdSize {
  banner,
  mrec,
  leader,
}

class BannerPx {
  final double width;
  final double height;
  BannerPx(this.width, this.height);
}

class ApplovinMaxBannerView extends StatelessWidget {
  final AppLovinListener? appLovinListener;
  final BannerAdSize? size;
  ApplovinMaxBannerView({
    Key? key,
    this.size,
    this.appLovinListener,
  }) : super(key: key);

  final Map<BannerAdSize, String> sizes = {
    BannerAdSize.banner: 'BANNER',
    BannerAdSize.leader: 'LEADER',
    BannerAdSize.mrec: 'MREC'
  };

  final Map<BannerAdSize, BannerPx> sizesNum = {
    BannerAdSize.banner: BannerPx(350, 50),
    BannerAdSize.leader: BannerPx(double.infinity, 90),
    BannerAdSize.mrec: BannerPx(300, 250)
  };

  @override
  Widget build(BuildContext context) {
    var androidView = AndroidView(
      viewType: '/bannerView',
      key: UniqueKey(),
      creationParams: {'Size': sizes[size]},
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int? i) {
        if (appLovinListener != null) {
          const MethodChannel channel = MethodChannel('applovin_max');
          channel.setMethodCallHandler((MethodCall call) async =>
              ApplovinMaxPlatform.instance
                  .handleMethod(call, appLovinListener!));
        }
      },
    );
    return SizedBox(
        width: sizesNum[size]?.width,
        height: sizesNum[size]?.height,
        child: Platform.isAndroid ? androidView : Container());
  }
}

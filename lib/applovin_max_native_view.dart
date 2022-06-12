

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'applovin_max_method_channel.dart';
import 'applovin_max_platform_interface.dart';

enum NativeAdType {
  small,
  medium,
}

class BannerPx {
  final double width;
  final double height;
  BannerPx(this.width, this.height);
}

class ApplovinMaxNativeView extends StatelessWidget {
  final AppLovinListener? appLovinListener;
  final NativeAdType? size;
  ApplovinMaxNativeView({
    Key? key,
    this.size,
    this.appLovinListener,
  }) : super(key: key);

   final Map<NativeAdType, BannerPx> sizesNum = {
    NativeAdType.small:  BannerPx(360, 60),
    NativeAdType.medium: BannerPx(300, 250),
  };

  @override
  Widget build(BuildContext context) {
    var androidView = AndroidView(
      viewType: '/nativeView',
      key: UniqueKey(),
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int? i){
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
      child: Platform.isAndroid ? androidView : Container()
    );
  }
}

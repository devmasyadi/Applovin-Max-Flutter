import 'package:applovin_max/applovin_max_banner_view.dart';
import 'package:applovin_max/applovin_max_method_channel.dart';
import 'package:applovin_max/applovin_max_native_view.dart';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _applovinMaxPlugin = ApplovinMax();
  String _event = "";
  bool _isShowBanner = false;
  bool _isShowNative = false;

  @override
  void initState() {
    super.initState();
  }

  void _listener(AppLovinAdListener? appLovinAdListener) {
    // ignore: avoid_print
    print("appLovinAdListener: $appLovinAdListener");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ApplovinMax Flutter'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _applovinMaxPlugin.setAdUnit(
                      bannerId: "a9cf30664af0cafd",
                      interstitialId: "37bee3aa561caa00",
                      nativeId: "117ad74db422cb93",
                      rewardsAdsId: "50abdd7e9a3fcd0a");
                },
                child: const Text("SetAdUnit"),
              ),
              ElevatedButton(
                onPressed: () {
                  _applovinMaxPlugin.initSdk(
                    appLovinInitListener: (isInitialized) {
                      setState(() {
                        _event = "isInitialized: $isInitialized";
                      });
                    },
                  );
                },
                child: const Text("Init Sdk"),
              ),
              ElevatedButton(
                onPressed: () {
                  _applovinMaxPlugin.createInterstitial(appLovinListener: _listener);
                },
                child: const Text("Create Int"),
              ),
              ElevatedButton(
                onPressed: () {
                  _applovinMaxPlugin.showInterstitial();
                },
                child: const Text("Show Int"),
              ),
              ElevatedButton(
                onPressed: () {
                  _applovinMaxPlugin.createRewards(appLovinListener: _listener);
                },
                child: const Text("Create Rwd"),
              ),
              ElevatedButton(
                onPressed: () {
                  _applovinMaxPlugin.showRewards();
                },
                child: const Text("Show Rwd"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isShowBanner = true;
                  });
                },
                child: const Text("Show Banner"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isShowNative = true;
                  });
                },
                child: const Text("Show Native"),
              ),
              if (_isShowBanner)
                ApplovinMaxBannerView(
                  appLovinListener: _listener,
                  size: BannerAdSize.banner,
                ),
              if (_isShowNative)
                ApplovinMaxNativeView(
                  appLovinListener: _listener,
                  size: NativeAdType.medium,
                ),
              Text(
                'Event: $_event',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

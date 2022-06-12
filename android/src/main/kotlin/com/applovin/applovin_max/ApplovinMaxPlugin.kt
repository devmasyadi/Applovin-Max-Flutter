package com.applovin.applovin_max

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ApplovinMaxPlugin */
class ApplovinMaxPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applovinMaxManager: ApplovinMaxManager

    companion object {
        val TAG = ApplovinMaxManager::class.simpleName
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "applovin_max")
        channel.setMethodCallHandler(this)
        applovinMaxManager = ApplovinMaxManager(channel)
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("/nativeView", NativeViewFactory(channel))
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("/bannerView", BannerViewFactory(channel))

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initSdk" -> applovinMaxManager.init()
            "setAdUnit" -> setAdUnit(call)
            "createInterstitial" -> applovinMaxManager.createInterstitialAd()
            "showInterstitial" -> applovinMaxManager.showInterstitial()
            "createRewards" -> applovinMaxManager.createRewardedAd()
            "showRewards" -> applovinMaxManager.showRewards()
            else ->
                result.notImplemented()

        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        applovinMaxManager.setActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }

    private fun setAdUnit(
        call: MethodCall
    ) {
        call.argument<String>("bannerId")?.let {
            ConfigAdsApplovin.bannerId = it
        }
        call.argument<String>("interstitialId")?.let {
            ConfigAdsApplovin.interstitialId = it
        }
        call.argument<String>("nativeId")?.let {
            ConfigAdsApplovin.nativeId = it
        }
        call.argument<String>("rewardsAdsId")?.let {
            ConfigAdsApplovin.rewardsAdsId = it
        }
    }
}

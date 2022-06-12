package com.applovin.applovin_max

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.applovin.mediation.*
import com.applovin.mediation.ads.MaxInterstitialAd
import com.applovin.mediation.ads.MaxRewardedAd
import com.applovin.sdk.AppLovinMediationProvider
import com.applovin.sdk.AppLovinSdk
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit
import kotlin.math.pow

class ApplovinMaxManager(
    private val methodeChannel: MethodChannel
) {

    private lateinit var activity: Activity

    fun setActivity(activity: Activity) {
        this.activity = activity
    }

    fun init() {
        AppLovinSdk.getInstance(activity).mediationProvider = AppLovinMediationProvider.MAX
        AppLovinSdk.getInstance(activity).initializeSdk {
            // AppLovin SDK is initialized, start loading ads
            invokeOnAdEvent("onAdInitialized", hashMapOf("isInitialized" to true))
        }
    }

    private fun invokeOnAdEvent(methode: String, arguments: Map<Any, Any>) {
        Handler(Looper.getMainLooper())
            .post { methodeChannel.invokeMethod(methode, arguments) }
    }

    private lateinit var interstitialAd: MaxInterstitialAd
    private var retryAttempt = 0.0

    fun createInterstitialAd() {
        interstitialAd = MaxInterstitialAd(ConfigAdsApplovin.interstitialId, activity)
        interstitialAd.setListener(interstitialListener)

        // Load the first ad
        interstitialAd.loadAd()
    }

    fun showInterstitial() {
        if (interstitialAd.isReady) {
            interstitialAd.showAd()
        } else
            interstitialAd.loadAd()
    }

    private val interstitialListener = object : MaxAdListener {
        // MAX Ad Listener
        override fun onAdLoaded(maxAd: MaxAd) {
            // Interstitial ad is ready to be shown. interstitialAd.isReady() will now return 'true'

            // Reset retry attempt
            retryAttempt = 0.0
            invokeOnAdEvent("onAdLoaded", hashMapOf("maxAd" to maxAd.toString()))
        }

        override fun onAdLoadFailed(adUnitId: String?, error: MaxError) {
            // Interstitial ad failed to load
            // AppLovin recommends that you retry with exponentially higher delays up to a maximum delay (in this case 64 seconds)

            retryAttempt++
            val delayMillis =
                TimeUnit.SECONDS.toMillis(2.0.pow(6.0.coerceAtMost(retryAttempt)).toLong())

            Handler().postDelayed({ interstitialAd.loadAd() }, delayMillis)
            invokeOnAdEvent(
                "onAdLoadFailed",
                hashMapOf("adUnitId" to adUnitId.toString(), "error" to error.toString())
            )
        }

        override fun onAdDisplayFailed(ad: MaxAd?, error: MaxError) {
            // Interstitial ad failed to display. AppLovin recommends that you load the next ad.
            interstitialAd.loadAd()
            invokeOnAdEvent(
                "onAdDisplayFailed",
                hashMapOf("ad" to ad.toString(), "error" to error.toString())
            )
        }

        override fun onAdDisplayed(maxAd: MaxAd) {}

        override fun onAdClicked(maxAd: MaxAd) {}

        override fun onAdHidden(maxAd: MaxAd) {
            // Interstitial ad is hidden. Pre-load the next ad
            interstitialAd.loadAd()
        }

    }

    private lateinit var rewardedAd: MaxRewardedAd
    private var retryAttemptRwd = 0.0

    fun createRewardedAd() {
        rewardedAd = MaxRewardedAd.getInstance(ConfigAdsApplovin.rewardsAdsId, activity)
        rewardedAd.setListener(maxRewardedAdListener)

        rewardedAd.loadAd()
    }

    fun showRewards() {
        if (rewardedAd.isReady) {
            rewardedAd.showAd();
        } else
            rewardedAd.loadAd()
    }

    private val maxRewardedAdListener = object : MaxRewardedAdListener {
        // MAX Ad Listener
        override fun onAdLoaded(maxAd: MaxAd) {
            // Rewarded ad is ready to be shown. rewardedAd.isReady() will now return 'true'

            // Reset retry attempt
            retryAttemptRwd = 0.0
            Utils.invokeOnAdEvent(
                methodeChannel,
                "onAdLoaded",
                hashMapOf("maxAd" to maxAd.toString())
            )
        }

        override fun onAdLoadFailed(adUnitId: String?, error: MaxError?) {
            // Rewarded ad failed to load
            // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)

            retryAttemptRwd++
            val delayMillis =
                TimeUnit.SECONDS.toMillis(2.0.pow(6.0.coerceAtMost(retryAttemptRwd)).toLong())

            Handler().postDelayed({ rewardedAd.loadAd() }, delayMillis)
            invokeOnAdEvent(
                "onAdLoadFailed",
                hashMapOf("adUnitId" to adUnitId.toString(), "error" to error.toString())
            )
        }

        override fun onAdDisplayFailed(ad: MaxAd?, error: MaxError?) {
            // Rewarded ad failed to display. We recommend loading the next ad
            rewardedAd.loadAd()
        }

        override fun onAdDisplayed(maxAd: MaxAd) {}

        override fun onAdClicked(maxAd: MaxAd) {}

        override fun onAdHidden(maxAd: MaxAd) {
            // rewarded ad is hidden. Pre-load the next ad
            rewardedAd.loadAd()
        }

        override fun onRewardedVideoStarted(maxAd: MaxAd) {}

        override fun onRewardedVideoCompleted(maxAd: MaxAd) {}

        override fun onUserRewarded(maxAd: MaxAd, maxReward: MaxReward) {
            // Rewarded ad was displayed and user should receive the reward
            Utils.invokeOnAdEvent(
                methodeChannel,
                "onUserRewarded",
                hashMapOf("maxAd" to maxAd.toString(), "maxReward" to maxReward.toString())
            )
        }
    }


}

package com.applovin.applovin_max

import android.app.Activity
import android.os.Handler
import android.os.Looper
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxInterstitialAd
import com.applovin.sdk.AppLovinMediationProvider
import com.applovin.sdk.AppLovinSdk
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit
import kotlin.math.pow

class ApplovinMaxManager(
    private val methodeChannel: MethodChannel
) {

    companion object {
        const val TAG = "ApplovinMaxManager"
    }

    private lateinit var activity: Activity

    fun setActivity(activity: Activity) {
        this.activity = activity
    }

    fun init() {
        AppLovinSdk.getInstance(activity).mediationProvider = AppLovinMediationProvider.MAX
        AppLovinSdk.getInstance(activity).initializeSdk {
            // AppLovin SDK is initialized, start loading ads
            invokeOnAdEvent("onAdInitialized", hashMapOf("isInitialized" to true))
            createInterstitialAd()
        }
    }

    private fun invokeOnAdEvent(methode: String, arguments: Map<Any, Any>) {
        Handler(Looper.getMainLooper())
            .post { methodeChannel.invokeMethod(methode, arguments) }
    }

    private lateinit var interstitialAd: MaxInterstitialAd
    private var retryAttempt = 0.0

    private fun createInterstitialAd() {
        interstitialAd = MaxInterstitialAd(ConfigAdsApplovin.interstitialId, activity)
        interstitialAd.setListener(interstitialListener)

        // Load the first ad
        interstitialAd.loadAd()
    }

    fun showInterstitial() {
        if (interstitialAd.isReady) {
            interstitialAd.showAd()
        } else
            createInterstitialAd()
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
}

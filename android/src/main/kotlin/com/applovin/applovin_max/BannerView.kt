package com.applovin.applovin_max

import android.content.Context
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAdView
import com.applovin.sdk.AppLovinAdSize
import com.applovin.sdk.AppLovinSdkUtils
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BannerView(
    private val context: Context?,
    private val methodeChannel: MethodChannel,
    creationParams: Map<String?, Any?>?
) : PlatformView {

    private var banner: MaxAdView? = null
    private val sizes: HashMap<String, AppLovinAdSize> =
        object : HashMap<String, AppLovinAdSize>() {
            init {
                put("BANNER", AppLovinAdSize.BANNER)
                put("MREC", AppLovinAdSize.MREC)
                put("LEADER", AppLovinAdSize.LEADER)
            }
        }

    private val bannerListener = object : MaxAdViewAdListener {
        // MAX Ad Listener
        override fun onAdLoaded(maxAd: MaxAd) {
            Utils.invokeOnAdEvent(
                methodeChannel,
                "onAdLoaded",
                hashMapOf("maxAd" to maxAd.toString())
            )
        }

        override fun onAdLoadFailed(adUnitId: String?, error: MaxError) {}

        override fun onAdDisplayFailed(ad: MaxAd?, error: MaxError) {}

        override fun onAdClicked(maxAd: MaxAd) {}

        override fun onAdExpanded(maxAd: MaxAd) {}

        override fun onAdCollapsed(maxAd: MaxAd) {}

        override fun onAdDisplayed(maxAd: MaxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */
        }

        override fun onAdHidden(maxAd: MaxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */
        }
    }

    init {
        var size: AppLovinAdSize = AppLovinAdSize.BANNER
        sizes[creationParams?.get("Size")]?.let {
            size = it
        }

        banner = MaxAdView(ConfigAdsApplovin.bannerId, context)
        banner?.setListener(bannerListener)
        val layout: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            this.dpToPx(context, size.width), this.dpToPx(context, size.height)
        )
        layout.gravity = Gravity.CENTER
        banner?.layoutParams = layout
        // Load the ad
        banner?.loadAd()
    }

    private fun dpToPx(context: Context?, dp: Int): Int {
        return AppLovinSdkUtils.dpToPx(context, dp)
    }

    override fun getView(): View? {
        return banner
    }

    override fun dispose() {

    }
}
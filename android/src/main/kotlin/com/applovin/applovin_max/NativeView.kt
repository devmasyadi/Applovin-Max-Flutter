package com.applovin.applovin_max

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxError
import com.applovin.mediation.nativeAds.MaxNativeAdListener
import com.applovin.mediation.nativeAds.MaxNativeAdLoader
import com.applovin.mediation.nativeAds.MaxNativeAdView
import io.flutter.plugin.platform.PlatformView

class NativeView(private val context: Context?, private val creationParams: Map<String?, Any?>?): PlatformView {

    private var nativeAdLoader: MaxNativeAdLoader =
        MaxNativeAdLoader(ConfigAdsApplovin.nativeId, context )
    private var nativeAd: MaxAd? = null
    private var nativeAdContainer: FrameLayout? = null

    companion object {
        const val TAG = "ApplovinMaxNativeView"
    }

   init {
       nativeAdContainer = context?.let { FrameLayout(it) }
       nativeAdContainer?.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)
       nativeAdLoader.setNativeAdListener(object : MaxNativeAdListener() {
           override fun onNativeAdLoaded(nativeAdView: MaxNativeAdView?, ad: MaxAd?)
           {
               // Clean up any pre-existing native ad to prevent memory leaks.
               if ( nativeAd != null )
               {
                   nativeAdLoader.destroy( nativeAd )
               }

               // Save ad for cleanup.
               nativeAd = ad

               // Add ad view to view.
               nativeAdContainer?.removeAllViews()
               nativeAdContainer?.addView(nativeAdView)
               Log.i(TAG, "onNativeAdLoaded: ${ad.toString()} nativeAdContainer: $nativeAdContainer")
           }

           override fun onNativeAdLoadFailed(adUnitId: String, error: MaxError)
           {
               // We recommend retrying with exponentially higher delays up to a maximum delay
               Log.e(TAG, "onNativeAdLoadFailed, adUnit: $adUnitId, error: $error")
           }

           override fun onNativeAdClicked(ad: MaxAd)
           {
               // Optional click callback
           }
       })
       nativeAdLoader.loadAd()
   }
    override fun getView(): View? {
        return nativeAdContainer
    }

    override fun dispose() {

    }
}
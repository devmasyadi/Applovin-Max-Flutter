package com.applovin.applovin_max

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel

object Utils {
    fun invokeOnAdEvent(methodeChannel: MethodChannel, methode: String, arguments: Map<Any, Any>) {
        Handler(Looper.getMainLooper())
            .post { methodeChannel.invokeMethod(methode, arguments) }
    }
}
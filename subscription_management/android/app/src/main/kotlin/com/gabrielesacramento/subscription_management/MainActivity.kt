package com.gabrielesacramento.subscription_management

import android.os.Bundle
import androidx.core.content.ContextCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.renderer.FlutterUiDisplayListener

class MainActivity : FlutterActivity() {
    private var isFlutterUiDisplayed = false

    override fun onCreate(savedInstanceState: Bundle?) {
        val splashScreen = installSplashScreen()
        splashScreen.setKeepOnScreenCondition { !isFlutterUiDisplayed }

        super.onCreate(savedInstanceState)

        val splashBackground = ContextCompat.getColor(this, R.color.splash_background)
        window.setBackgroundDrawableResource(R.color.splash_background)
        window.statusBarColor = splashBackground
        window.navigationBarColor = splashBackground
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.renderer.addIsDisplayingFlutterUiListener(
            object : FlutterUiDisplayListener {
                override fun onFlutterUiDisplayed() {
                    isFlutterUiDisplayed = true
                }

                override fun onFlutterUiNoLongerDisplayed() {
                    isFlutterUiDisplayed = false
                }
            },
        )
    }
}

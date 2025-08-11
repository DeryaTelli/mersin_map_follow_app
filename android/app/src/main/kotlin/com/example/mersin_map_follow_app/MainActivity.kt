package com.example.mersin_map_follow_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("db3d39a9-825d-4ecf-a223-5f0552eb1dd8")
        MapKitFactory.setLocale("tr_TR ")
        super.configureFlutterEngine(flutterEngine)
    }
}

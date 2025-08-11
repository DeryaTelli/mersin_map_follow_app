package com.example.mersin_map_follow_app
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory
class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MapKitFactory.setLocale("tr_TR")
        MapKitFactory.setApiKey("4a9fdbd0-419f-45d0-8e7b-c76cba13426b")
        super.configureFlutterEngine(flutterEngine)
    }
}
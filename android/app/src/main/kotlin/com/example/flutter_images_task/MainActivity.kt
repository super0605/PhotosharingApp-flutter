package com.example.flutter_images_task

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private var startString:String? = null
    private var linksReceiver:BroadcastReceiver? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun onCreate(savedInstanceState:Bundle?) {
        super.onCreate(savedInstanceState)

        val intent = intent
        val data = intent.data

        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "initialLink") {
                if (startString != null) {
                    result.success(startString)
                }
            }
        }

        EventChannel(flutterEngine?.dartExecutor, EVENTS).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                        linksReceiver = createChangeReceiver(events)
                    }

                    override fun onCancel(arguments: Any?) {
                        linksReceiver = null
                    }
                }
        )


        if (data != null)
        {
            startString = data.toString()
            if (linksReceiver != null)
            {
                linksReceiver!!.onReceive(this.applicationContext, intent)
            }
        }
    }

    public override fun onNewIntent(intent:Intent) {
        super.onNewIntent(intent)
        if (intent.action === Intent.ACTION_VIEW && linksReceiver != null)
        {
            linksReceiver!!.onReceive(this.applicationContext, intent)
        }
    }


    private fun createChangeReceiver(events:EventChannel.EventSink):BroadcastReceiver {
        return object:BroadcastReceiver() {
            override fun onReceive(context:Context, intent:Intent) {
                // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW

                val dataString = intent.dataString

                if (dataString == null)
                {
                    events.error("UNAVAILABLE", "Link unavailable", null)
                }
                else
                {
                    events.success(dataString)
                }
            }
        }
    }

    companion object {
        private const val CHANNEL = "http.deeplink.littleapps.com/cnannel"
        private const val EVENTS = "http.deeplink.littleapps.com/events"
    }
}
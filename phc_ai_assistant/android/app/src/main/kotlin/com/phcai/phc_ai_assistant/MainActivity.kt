package com.phcai.phc_ai_assistant

import android.content.Intent
import android.provider.Settings
import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "phc_ai/voice_setup"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Launch the system Text-To-Speech voice-data downloader. Android
                    // does not allow silent install of voice packs, so this opens the
                    // OS installer where the user confirms the download.
                    "installTtsData" -> {
                        try {
                            val intent = Intent(TextToSpeech.Engine.ACTION_INSTALL_TTS_DATA)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("NO_TTS_INSTALLER", e.message, null)
                        }
                    }
                    // Open voice-input settings so the user can download offline
                    // speech-recognition language packs.
                    "openVoiceInputSettings" -> {
                        try {
                            val intent = Intent(Settings.ACTION_VOICE_INPUT_SETTINGS)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            try {
                                val fallback = Intent(Settings.ACTION_SETTINGS)
                                fallback.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                startActivity(fallback)
                                result.success(true)
                            } catch (e2: Exception) {
                                result.error("NO_SETTINGS", e2.message, null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}

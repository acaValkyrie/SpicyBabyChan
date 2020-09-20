package com.flutter.speech_recognition.flutter_speech;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;

import androidx.core.app.ActivityCompat;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.ArrayList;

import android.media.AudioManager;
import android.content.IntentFilter;
import android.content.Context;
import android.content.BroadcastReceiver;
import java.lang.ref.WeakReference;

/** FlutterSpeechRecognitionPlugin */
public class FlutterSpeechRecognitionPlugin implements MethodCallHandler, RecognitionListener, PluginRegistry.RequestPermissionsResultListener {

  private static final String LOG_TAG = "FlutterSpeechPlugin";
  private static final String ERROR_TAG = "FlutterSpeechError";
  private static final int MY_PERMISSIONS_RECORD_AUDIO = 16669;
  private SpeechRecognizer speech;
  private MethodChannel speechChannel;
  private String transcription = "";
  private Intent recognizerIntent;
  private Activity activity;
  private Result permissionResult;

  private AudioManager mAudioManager;
  int maMusicVol,maAlarmVol,maNortVol;
  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.flutter.speech_recognition");
    final FlutterSpeechRecognitionPlugin plugin = new FlutterSpeechRecognitionPlugin(registrar.activity(), channel);
    channel.setMethodCallHandler(plugin);
    registrar.addRequestPermissionsResultListener(plugin);
  }

  private FlutterSpeechRecognitionPlugin(Activity activity, MethodChannel channel) {
    this.speechChannel = channel;
    this.speechChannel.setMethodCallHandler(this);
    this.activity = activity;

    speech = SpeechRecognizer.createSpeechRecognizer(activity.getApplicationContext());
    speech.setRecognitionListener(this);

    mAudioManager = (AudioManager)activity.getApplicationContext().getSystemService(Context.AUDIO_SERVICE);
    //private Context mContext = activity();

    //黙れflutter_speech!!!!!!!!!!!!!!
    mAudioManager.setStreamVolume(AudioManager.STREAM_MUSIC, 0/*音量*/, 0);
    //mAudioManager.setAudioStreamType(AudioManager.STREAM_ALARM);
    //println(mAvolume);

    recognizerIntent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
    recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
    recognizerIntent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true);
    recognizerIntent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3);
    maMusicVol = mAudioManager != null ? mAudioManager.getStreamVolume(AudioManager.STREAM_MUSIC) : -1;
    maAlarmVol = mAudioManager != null ? mAudioManager.getStreamVolume(AudioManager.STREAM_ALARM) : -1;
    maNortVol = mAudioManager != null ? mAudioManager.getStreamVolume(AudioManager.STREAM_NOTIFICATION) : -1;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "speech.activate":
        Log.d(LOG_TAG, "Current Locale : " + call.arguments.toString());
        recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, getLocaleCode(call.arguments.toString()));

        if (activity.checkCallingOrSelfPermission(Manifest.permission.RECORD_AUDIO)
                == PackageManager.PERMISSION_GRANTED) {
            result.success(true);
        } else {
          permissionResult = result;
          ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.RECORD_AUDIO}, MY_PERMISSIONS_RECORD_AUDIO);
        }

        break;
      case "speech.listen":
        //SpeechRecognizerのstartListeningを実行
        speech.startListening(recognizerIntent);
        result.success(true);
        break;
      case "speech.cancel":
        speech.cancel();
        result.success(false);
        break;
      case "speech.stop":
        speech.stopListening();
        result.success(true);
        break;
      case "speech.destroy":
        speech.cancel();
        speech.destroy();
        result.success(true);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private String getLocaleCode(String code) {
    return code.replace("_", "-");
  }

  @Override
  public void onReadyForSpeech(Bundle params) {
    Log.d(LOG_TAG, "onReadyForSpeech");
    speechChannel.invokeMethod("speech.onSpeechAvailability", true);
  }

  @Override
  public void onBeginningOfSpeech() {
    Log.d(LOG_TAG, "onRecognitionStarted");
    transcription = "";
    speechChannel.invokeMethod("speech.onRecognitionStarted", null);
  }

  @Override
  public void onRmsChanged(float rmsdB) {
    Log.d(LOG_TAG, "onRmsChanged : " + rmsdB);
  }

  @Override
  public void onBufferReceived(byte[] buffer) {
    Log.d(LOG_TAG, "onBufferReceived");
  }

  @Override
  public void onEndOfSpeech() {
    Log.d(LOG_TAG, "onEndOfSpeech");
    speechChannel.invokeMethod("speech.onRecognitionComplete", transcription);
    //speech.destroy();
  }

  @Override
  public void onError(int error) {
    Log.d(LOG_TAG, "onError : " + error);
    String errorMessage = "";
    switch(error){
      case 1:
        errorMessage = "ネットワークがタイムアウトしました。";
        break;
      case 2:
        errorMessage = "ネットワークエラー";
        break;
      case 3:
        errorMessage = "Audio recording error";
        break;
      case 4:
        errorMessage = "サーバー側でエラーが発生しました。";
        break;
      case 5:
        errorMessage = "Other client side errors";
        break;
      case 6:
        errorMessage = "音声入力がありませんでした。";
        break;
      case 7:
        errorMessage = "認識結果が一致しません。";
        break;
      case 8:
        errorMessage = "今忙しいので音声認識できません。";
        break;
      case 9:
        errorMessage = "権限がありません。";
        break;
    }
    Log.e(ERROR_TAG,errorMessage);
    speechChannel.invokeMethod("speech.onSpeechAvailability", false);
    speechChannel.invokeMethod("speech.onError", error);
    //if(error == 6){
      //speech.destroy();
    //}
    //これだとだめかもしれないのでダメっぽかったら戻してください。
    //speech.destroy();
  }

  @Override
  public void onPartialResults(Bundle partialResults) {
    Log.d(LOG_TAG, "onPartialResults...");
    ArrayList<String> matches = partialResults
            .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
    if (matches != null) {
      transcription = matches.get(0);
    }
    sendTranscription(false);
  }

  @Override
  public void onEvent(int eventType, Bundle params) {
    Log.d(LOG_TAG, "onEvent : " + eventType);
  }

  @Override
  public void onResults(Bundle results) {
    Log.d(LOG_TAG, "onResults...");
    ArrayList<String> matches = results
            .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
    if (matches != null) {
      transcription = matches.get(0);
      Log.d(LOG_TAG, "onResults -> " + transcription);
      sendTranscription(true);
    }
    sendTranscription(false);
  }

  private void sendTranscription(boolean isFinal) {
    speechChannel.invokeMethod(isFinal ? "speech.onRecognitionComplete" : "speech.onSpeech", transcription);
  }

  @Override
  public boolean onRequestPermissionsResult(int code, String[] permissions, int[] results) {
    if (code == MY_PERMISSIONS_RECORD_AUDIO) {
      if(results[0] == PackageManager.PERMISSION_GRANTED) {
        permissionResult.success(true);
      } else {
        permissionResult.error("ERROR_NO_PERMISSION", "Audio permission are not granted", null);
      }
      permissionResult = null;
      return true;
    }
    return false;
  }
}

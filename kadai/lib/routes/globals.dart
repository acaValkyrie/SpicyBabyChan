library my_prj.globals;
import 'package:vibration/vibration.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

List<String> namedataG = ["せよぎ","seyogi","田中","chiba","千葉",];
//名前
List<bool> flagG = [false,false,false,false,];
//それぞれの名前をトリガにするか/しないか
bool backflag = false;//バックグラウンド動作
bool musicflag = false;//音楽再生
bool moveflag = false;//バイブレーション
bool callflag = false;
//test_route用
@override
String inputText = "";
String inputText2 = "";
@override
bool isListening = false;

<<<<<<< HEAD

=======
void callFunc(){

  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  final audio = Audio("assets/audios/_7thsence.mp3");

  Vibration.vibrate(duration: 500 ,amplitude: 128);
  _assetsAudioPlayer.open(
    audio,
    showNotification: true,
  );
}
>>>>>>> 8797b5f2a6eed85f8216659f7d42ceefd99218dd

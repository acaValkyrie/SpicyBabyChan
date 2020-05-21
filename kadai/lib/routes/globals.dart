library my_prj.globals;

List<String> namedataG = ["せよぎ","AngE・L"];
//名前
List<bool> flagG = [false,false];
//それぞれの名前をトリガにするか/しないか
bool backflag = false;//バックグラウンド動作
bool musicflag = false;//音楽再生
bool moveflag = false;//バイブレーション
bool callflag = false;
//test_route用
@override
String inputText = "";
@override
bool recordflag = false;
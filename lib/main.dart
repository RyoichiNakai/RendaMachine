import 'package:flutter/material.dart';
import 'package:rendamachine/transitions/transition.dart' show TransHall;
import 'package:quiver/async.dart';
import 'package:rendamachine/database/database_provider.dart';
import 'package:rendamachine/database/database_model.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

//toDo:フォントの大きさ等、数値ではなく画面のサイズにあわせたサイズにしたい
class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);
  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RendaMachine',
      theme: ThemeData(
          //ここ適応されないのなんで
          fontFamily: 'jupiter'),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/myhomepage': (BuildContext context) => new MyHomePage(),
        '/mygamepage': (BuildContext context) => new MyGamePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _modeButtonFlag = false;
  bool _10sMode = false;
  bool _60sMode = false;
  bool _endlessMode = false;
  var _your10sScore = '--';
  var _your60sScore = '--';
  var _yourEndlessScore = '--';
  static int _score;
  static String _yourName;
  static int _id = 0;
  var rnd = new Random();
  final TextEditingController _nameController = new TextEditingController();
  DbProvider10 _provider10 = new DbProvider10();
  DbProvider60 _provider60 = new DbProvider60();
  DbProviderEndless _providerEndless = new DbProviderEndless();
  User u = new User(_id, _yourName, _score);
  var _exploreList10sMode;
  var _exploreList60sMode;
  var _exploreListEndlessMode;

  // 今のカウントを保存する
  _saveName(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("myName", name);
  }

  _readName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var data = pref.getString("myName");
      if (data != null) {
        _nameController.text = data;
        _yourName = data;
      }
    });
  }

  _saveScore(String score1, String score2, String score3) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("10sScore", score1);
    await pref.setString("60sScore", score2);
    await pref.setString("EndlessScore", score3);
  }

   _readScore() async {
     SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var score1 = pref.getString("10sScore");
      var score2 = pref.getString("60sScore");
      var score3 = pref.getString("EndlessScore");
      if (score1 != null && score2 != null && score3 != null) {
        _your10sScore = score1;
        _your60sScore = score2;
        _yourEndlessScore = score3;
      }
    });
  }

  _saveMode(bool mode1, bool mode2, bool mode3, bool flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("10sMode", mode1);
    await pref.setBool("60sMode", mode2);
    await pref.setBool("EndlessMode", mode3);
    await pref.setBool("ModeButtonFlag", flag);
  }

  _readMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _10sMode = pref.getBool("10sMode") ?? false;
      _60sMode = pref.getBool("60sMode") ?? false;
      _endlessMode = pref.getBool("EndlessMode") ?? false;
      _modeButtonFlag = pref.getBool("ModeButtonFlag") ?? false;
    });

  }

  @override
  void initState() {
    _readName();
    _readScore();
    _readMode();
    return super.initState();
  }

  void _updateName(String name){
    setState(() {
      _yourName = name;
    });
  }

  void _updateScore(int score) {
    setState(() {
      _score = score;
    });
  }

  void _updateUser(){
    setState(() {
      u = User(_id, _yourName, _score);
    });
  }

  void _setID(int id){
    setState(() {
      _id = id;
    });
  }

  void _updateID() {
    setState(() {
      _id = rnd.nextInt(10)
          + rnd.nextInt(10) * 10
          + rnd.nextInt(10) * 100
          + rnd.nextInt(10) * 1000
          + rnd.nextInt(10) * 10000
          + rnd.nextInt(10) * 100000;
    });
  }

  Future<String> _displayScoreRanking() async{
    //この行を追加したらLeaderBoardにランキングが表示されるようになった、awaitで待ったおかげ？？
    await new Future.delayed(new Duration(milliseconds: 500));
    String s = "";
    if(_10sMode){
      var list = await _provider10.getScore();
      for(int i = 0; i < list.length; i++){
        if(i > 9) break;
        var un = list[i]['username'];
        var sr = list[i]['score'];
        if(i == 0){
          s += " ${i+1}: $un $sr";
        }else{
          s += "\n ${i+1}: $un $sr";
        }
      }
    }
    else if(_60sMode){
      var list = await _provider60.getScore();
      for(int i = 0; i < list.length; i++){
        if(i > 9) break;
        var un = list[i]['username'];
        var sr = list[i]['score'];
        if(i == 0){
          s += " ${i+1}: $un $sr";
        }else{
          s += "\n ${i+1}: $un $sr";
        }
      }
    }
    else if(_endlessMode){
      var list = await _providerEndless.getScore();
      for(int i = 0; i < list.length; i++){
        if(i > 9) break;
        var un = list[i]['username'];
        var sr = list[i]['score'];
        if(i == 0){
          s += " ${i+1}: $un $sr";
        }else{
          s += "\n ${i+1}: $un $sr";
        }
      }
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    _provider10.init();
    _provider60.init();
    _providerEndless.init();
    _saveScore(_your10sScore, _your60sScore, _yourEndlessScore);
    _saveMode(_10sMode, _60sMode, _endlessMode, _modeButtonFlag);


    Widget modeRecode = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildModeRecord('10s', _your10sScore)
          ),
          Expanded(
            child: _buildModeRecord('60s', _your60sScore)
          ),
          Expanded(
            child: _buildModeRecord('ENDLESS', _yourEndlessScore),
          )
        ],
      ),
    );

    Widget titleSection = Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Center(
        child: Text(
          'Renda\nMachine',
          textAlign: TextAlign.center,
          style: TextStyle(
            //toDo:fontfamilyをグローバル変数みたいな感じでかきたい
            fontFamily: 'jupiter',
            height: 0.6,
            fontSize: 70,
            color: Colors.white,
          ),
        ),
      ),
    );

    Widget nameSection = Container(
      height: 70.0,
      padding: const EdgeInsets.only(left: 85, right: 85),
      child: _buildTextForm(),
    );

    Widget modeButtonSection = Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 240.0,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildModeButton('10s', _10sMode),
            _buildModeButton('60s', _60sMode),
            _buildModeButton('ENDLESS', _endlessMode),
          ],
        ),
        SpaceBox.height(15),
        _buildPlayButton(),
        SpaceBox.height(15),
      ]),
    );

    Widget bottomSection = Row(
      children: <Widget>[
        SpaceBox(width: 10),
        Container(
          height: 200,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'FONT:\n'
                  'Isurus Labs\n'
                  'Grand Chaos Productions\n\n'
                  'ICON:\n'
                  'RyoichiNakai\n\n'
                  'SPECIAL THANKS\n'
                  'sinProject\n\n'
                  'RyoichiNakai', //ここ変更
              style: TextStyle(
                  fontFamily: 'jupiter',
                  color: Colors.white,
                  fontSize: 20,
                  height: 0.8),
            ),
          ),
        ),
        SpaceBox(width: 20),
        Expanded(
          child: _buildLeaderBoard(),
        ),
        SpaceBox(width: 10)
      ],
    );

    return MaterialApp(
      home: Scaffold(
        //キーボード出力時にレイアウトが動かないようにする
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/space.jpg"),
                    fit: BoxFit.cover,
                  ),
                ), //ここまでが背景画像
              ),
              SafeArea(
                //メニューバーを回避
                child: SingleChildScrollView(
                  //キーボード表示した時のエラーの対処
                  child: Column(
                    children: [
                      modeRecode,
                      titleSection,
                      nameSection,
                      modeButtonSection,
                      bottomSection
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildModeRecord(String mode, String record) {
    return Column(
      //columnの中の文字を真ん中に表示する, start>左づめ, end>右づめ
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          //Containerにして上に余白入れたほうがいいかも
          mode,
          style: TextStyle(
            fontFamily: 'jupiter',
            fontSize: 26.0,
            color: Colors.yellow,
          ),
        ),
        Text(
          record,
          style: TextStyle(
              fontFamily: 'jupiter',
              fontSize: 26.0,
              color: Colors.white,
              height: 0.4),
        ),
      ],
    );
  }

  TextFormField _buildTextForm() {
    return TextFormField(
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'jupiter',
        fontSize: 28,
      ),
      maxLength: 8,
      decoration: InputDecoration(
        hintText: 'Enter NickName...',
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        filled: true, //この行がないと背景色を変えれない
      ),
      controller: _nameController,
      onChanged: (value) {
        //名前の状態の保存
        _updateName(value);
      },
      onEditingComplete: () async{
        //キーボードが下がらなくなるバグを解決
        FocusScope.of(context).requestFocus(new FocusNode());
        _saveName(_yourName);
        _exploreList10sMode = await _provider10.getName(_yourName);
        _exploreList60sMode = await _provider60.getName(_yourName);
        _exploreListEndlessMode = await _providerEndless.getName(_yourName);
        if(!_10sMode && !_60sMode && !_endlessMode){
          setState(() {
            _10sMode = true;
          });
        }
        if(_exploreList10sMode.length > 0 || _exploreList60sMode.length > 0
            || _exploreListEndlessMode.length > 0) {
          setState(() {
            _modeButtonFlag = true;
            _your10sScore = '0';
            _your60sScore = '0';
            _yourEndlessScore = '0';
            if(_exploreList10sMode.length > 0) {
              _setID(_exploreList10sMode[0]['id']);
              _your10sScore = _exploreList10sMode[0]['score'].toString();
            }
            if(_exploreList60sMode.length > 0) {
              _setID(_exploreList60sMode[0]['id']);
              _your60sScore = _exploreList60sMode[0]['score'].toString();
            }
            if(_exploreListEndlessMode.length > 0) {
              _setID(_exploreListEndlessMode[0]['id']);
              _yourEndlessScore = _exploreListEndlessMode[0]['score'].toString();
            }
          });
        } else if (_yourName.length > 0) {
          _updateID();
          setState(() {
            _modeButtonFlag = true;
            _your10sScore = '0';
            _your60sScore = '0';
            _yourEndlessScore = '0';
          });
        } else {
          setState(() {
            _modeButtonFlag = false;
            _your10sScore = '--';
            _your60sScore = '--';
            _yourEndlessScore = '--';
            _10sMode = false;
            _60sMode = false;
            _endlessMode = false;
          });
        }
      },
      //なぜかvalue.lengthでやるとうまくいかない
    );
  }

  Container _buildModeButton(String name, bool mode) {
    if (_modeButtonFlag) {
      return Container(
        width: 125,
        height: 60,
        child: RaisedButton(
          //横の空白は何？？
          color: mode == true
              ? Colors.red.withOpacity(0.3)
              : Colors.red.withOpacity(0.1),
          child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'jupiter',
                fontSize: 30,
              ),
          ),
          shape: BeveledRectangleBorder(
            side: BorderSide(
                color: mode == true ? Colors.red : Colors.red.withOpacity(0.5),
                width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(5),
          onPressed: () {
            setState(() {
              if (name == '10s') {
                _10sMode = true;
                _60sMode = false;
                _endlessMode = false;
              } else if (name == '60s') {
                _10sMode = false;
                _60sMode = true;
                _endlessMode = false;
              } else {
                _10sMode = false;
                _60sMode = false;
                _endlessMode = true;
              }
            });
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Container _buildPlayButton() {
    //引数多すぎた
    if (_modeButtonFlag) {
      return Container(
        //padding: const EdgeInsets.only(left:10, right:10),
        width: 385,
        height: 60,
        child: RaisedButton(
          //横の空白は何？？
            color: Colors.red.withOpacity(0.3),
            child: Text(
              'PLAY!',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'jupiter',
                fontSize: 50,
              ),
            ),
            shape: BeveledRectangleBorder(
              side: BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              if (_10sMode) {
                final result = await Navigator.push(
                  context,
                  TransHall.of(new MyGamePage(title: 'mygamepage', mode: '10s', counter: 0))
                      .quick(),
                );
                //if文とメソッドを中に全部突っ込んだらいけたのなんで？？
                if (result != null && int.parse(result) > int.parse(_your10sScore)) {
                  setState(() {
                    _your10sScore = result;
                    _updateScore(int.parse(result));
                    _updateUser();
                    _provider10.insertScore(u);
                  });
                }
              } else if (_60sMode) {
                final result = await Navigator.push(
                  context,
                  TransHall.of(new MyGamePage(title: 'mygamepage', mode: '60s', counter: 0))
                      .quick(),
                );
                //if文とメソッドを中に全部突っ込んだらいけたのなんで？？
                if (result != null && int.parse(result) > int.parse(_your60sScore)) {
                  setState(() {
                    _your60sScore = result;
                    _updateScore(int.parse(result));
                    _updateUser();
                    _provider60.insertScore(u);
                  });
                }
              } else {
                final result = await Navigator.push(
                  context,
                  TransHall.of(
                      new MyGamePage(title: 'mygamepage', mode: 'ENDLESS', counter: int.parse(_yourEndlessScore)))
                      .quick(),
                );
                //if文とメソッドを中に全部突っ込んだらいけたのなんで？？
                if (result != null && int.parse(result) > int.parse(_yourEndlessScore)) {
                  setState(() {
                    _yourEndlessScore = result;
                    _updateScore(int.parse(result));
                    _updateUser();
                    _providerEndless.insertScore(u);
                  });
                }
            }
          }
        ),
      );
    } else {
      return Container();
    }
  }

  Container _buildLeaderBoard(){
    return Container(
      height: 200,
      decoration: new BoxDecoration(
          border: Border.all(color: Colors.redAccent, width: 1.5),
          borderRadius: BorderRadius.circular(20),
      ),
      child:Container(
        child:Column(
          children: <Widget>[
            Align(
              alignment: Alignment(-0.8,-1),
              child: Text(
                'LeaderBoard',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'jupiter',
                  fontSize: 26,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: FutureBuilder(
                future: _displayScoreRanking(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  final hasData = snapshot.hasData;
                  print('10s:$_10sMode');
                  print('60s:$_60sMode');
                  print('endless:$_endlessMode');
                  if (hasData) {
                    print('表示できるよ');
                    return Text(
                        snapshot.data,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'nano',
                          fontSize: 16,
                          height: 1.0
                        ),
                    );
                  } else {
                    print('表示できないよ');
                    return Text('');
                  }
                },
              ),
            ),
          ],
        ),
      color: Colors.red.withOpacity(0.3)
      ),
      //color: Colors.red.withOpacity(0.3),
    );
  }
}

class MyGamePage extends StatefulWidget {
  MyGamePage({Key key, this.title, this.mode, this.counter}) : super(key: key);
  final String title; //遷移先の画面タイトル
  final String mode; //遷移先のモードの設定
  final int counter; //

  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  int _counter;
  int _start = 0;
  int _current = 0;
  bool _gamePlayFlag = false;
  bool _gameEndFlag = false;
  var _sec;
  var _millisec;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _setTimer() {
    if (widget.mode == '10s') {
      setState(() {
        _start = 10 * 1000;
        _current = 10 * 1000;
        _sec = 10;
        _millisec = 0;
      });
    }
    else if (widget.mode == '60s') {
      setState(() {
        _start = 60 * 1000;
        _current = 60 * 1000;
        _sec = 60;
        _millisec = 0;
      });
    }
  }

  //間違えてカウントダウンタイマーを作りました、、、
  void startTimer() {
   CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(milliseconds: _start),
      new Duration(milliseconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inMilliseconds;
        _sec = (_current / 1000).floor() % 60;
        _millisec = ((_current % 1000) / 10).floor(); //上二桁を表示
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
      setState(() {
        _gameEndFlag = true;
        _sec = 0;
        _millisec = 0;
      });
    });
  }

  //カウントダウンを見やすくするためのメソッド
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  @override
  Widget build(BuildContext context) {

    if(!_gamePlayFlag){
      _counter = widget.counter;
    }

    Widget topSection = Container(
        height: 90,
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: _buildTimer(widget.mode)),
            _buildQuitButton()
          ],
        ),
    );

    Widget mediumSection = Container(
        height: 100,
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: _buildCounter());

    Widget bottomSection =
        Container(height: 440, child: _buildCounterButtonList());

    return MaterialApp(
        home: Scaffold(
            body: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/space.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ), //ここまでが背景画像
                  ),
                  SafeArea(
                    child: Container(
                        child: Column(
                          children: <Widget>[
                            topSection,
                            mediumSection,
                            bottomSection
                          ],
                        )),
                  ),
                ],
              ),
            ),
        ),
    );
  }

  Text _buildTimer(String mode) {
    if(_counter == 0) _setTimer();
    if (widget.mode == 'ENDLESS') {
      return Text(
        'NO LIMIT',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'jupiter',
            fontSize: 60,
            height: 0.6
        ),
      );
    } else {
      return Text(
        formatTime(_sec) + '.' + formatTime(_millisec),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'jupiter',
            fontSize: 80,
            height: 0.6
        ),
      );
    }
  }

  Container _buildQuitButton() {
    return Container(
      width: 175,
      height: 60,
      child: RaisedButton(
        //横の空白は何？？
        child: Text(
            'QUIT',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'jupiter',
              fontSize: 50,
            )
        ),
        color: Colors.red.withOpacity(0.1),
        shape: BeveledRectangleBorder(
          side: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          if(_gameEndFlag || widget.mode == 'ENDLESS'){
            //popの中に入れるの文字列じゃないとダメぽい？？
            Navigator.of(context).pop(_counter.toString());
          } else{
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Text _buildCounter() {
    if (_gamePlayFlag || widget.mode == 'ENDLESS') {
      return Text(
          '$_counter',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'jupiter',
              fontSize: 90,
              height: 0.8
          ),
      );
    } else {
      return Text(
        'Press any button\nto start',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            height: 0.6,
            fontFamily: 'jupiter',
            fontSize: 65,
          ),
      );
    }
  }

  Container _buildCounterButtonList() {
    if (!_gameEndFlag) {
      return Container(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
            ],
          ),
          SpaceBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
            ],
          ),
          SpaceBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
            ],
          ),
          SpaceBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
              _buildCounterButton(),
            ],
          ),
          SpaceBox(height: 10),
        ],
      ),
      );
    } else {
      return Container(
        child: Text(
          "Time's Up!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'jupiter',
            fontSize: 100,
          ),
        ),
      );
    }
  }

  Container _buildCounterButton() {
    return Container(
      width: 80,
      height: 100,
      child: RaisedButton(
        color: Colors.red.withOpacity(0.1),
        shape: BeveledRectangleBorder(
          side: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        highlightElevation: 30.0,
        highlightColor: Colors.red.withOpacity(0.8),
        onHighlightChanged: (value) {},
        onPressed: () {
          if(_counter == 0 && widget.mode != 'ENDLESS') startTimer();
          setState((){
            _gamePlayFlag = true;
          });
          _incrementCounter();
        },
      ),
    );
  }
}

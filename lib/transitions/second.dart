import 'package:flutter/material.dart';


class SecondPage extends StatefulWidget{
  @override
  _SecondPageState createState() {
    // TODO: implement createState
    return new _SecondPageState();
  }
}


class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
            title: new Text('Second Page'),
            leading:
              new IconButton(
                icon: new Icon(Icons.chevron_left),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        ),
        body: new Center(
          child: new Text('Second Page'),
        ),
      ),
    );
  }
}
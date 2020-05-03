// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Demonstrate an AnimatedWidget with multiple Tweens.

import 'package:flutter/material.dart';

import 'second.dart';
import 'transition.dart';

/* Helpers */
dynamic getEnumValue(TRANSITION t) {
  return t.toString().split('.')[1].toUpperCase();
}

dynamic pascalCase(String word) => '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';

/* Routes */

enum TRANSITION {STANDARD, QUICK, SLIDE, SLIDE_UP, DISSOLVE, BOUNCE}

class Transition {
  Transition({@required this.name, @required this.pageRoute});

  final String name;
  var pageRoute;

  PageRoute getPageRoute(Widget widget) {
    return this.pageRoute(widget);
  }
}

// ignore: non_constant_identifier_names
final Map<int, Transition> Transitions = <Transition>[
  new Transition(name: pascalCase(getEnumValue(TRANSITION.STANDARD)) , pageRoute: (page) => TransHall.of(page).standard()),
  new Transition(name: pascalCase(getEnumValue(TRANSITION.QUICK)) , pageRoute: (page) => TransHall.of(page).quick()),
  new Transition(name: pascalCase(getEnumValue(TRANSITION.SLIDE)) , pageRoute: (page) => TransHall.of(page).slide()),
  new Transition(name: pascalCase(getEnumValue(TRANSITION.SLIDE_UP)) , pageRoute: (page) => TransHall.of(page).slideUp()),
  new Transition(name: pascalCase(getEnumValue(TRANSITION.DISSOLVE)) , pageRoute: (page) => TransHall.of(page).dissolve()),
  new Transition(name: pascalCase(getEnumValue(TRANSITION.BOUNCE)) , pageRoute: (page) => TransHall.of(page).bounce()),
].asMap();


/* App */

class App extends StatefulWidget {
  _TransitionState createState() => new _TransitionState();
}


class _TransitionState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Transitions'),
        ),
        body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int idx) {
            if (idx.isOdd) {
              return const Divider();
            }
            int _idx = idx ~/ 2;
            return new ListTile(
              title: new Text(
                Transitions[_idx].name,
                style: const TextStyle(fontSize: 16.0),

              ),
              onTap: () {
                Navigator.push(
                    context,
                    Transitions[_idx].getPageRoute(new SecondPage()),
                );
              },
            );

          },
          itemCount: Transitions.length*2,
        ),
      ),
    );
  }
}

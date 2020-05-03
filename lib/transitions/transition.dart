import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'second.dart';

class TransHall {
  final Widget widget;

  const TransHall({@required this.widget});

  const TransHall.of(this.widget);

  dynamic standard() => new MaterialPageRoute(builder: (context) => this.widget);

  dynamic quick() =>
      new PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return this.widget;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return new SlideTransition(
              position: new Tween(begin: Offset.zero, end: Offset.zero).animate(const AlwaysStoppedAnimation<double>(1.0)),
              child: child,
            );
          },
      );

  dynamic slide() => new CupertinoPageRoute(builder: (context) => this.widget);

  dynamic slideUp() =>
      new PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return this.widget;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return new SlideTransition(
              position: new Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(new CurvedAnimation(
                parent: animation, // The route's linear 0.0 - 1.0 animation.
                curve: Curves.decelerate,
              )),
              child: child,
            );
          }
      );

  dynamic dissolve() =>
      new PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return this.widget;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(
              opacity: new Tween(begin: 0.1, end: 1.0).animate(animation),
              child: child,
            );
          }
      );

  /*
  * Refer from https://medium.com/@agungsurya/create-custom-router-transition-in-flutter-using-pageroutebuilder-73a1a9c4a171
  * Author: Agung Surya<https://medium.com/@agungsurya?source=post_header_lockup>
  *
  * */
  dynamic bounce() =>
      new PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return this.widget;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return new ScaleTransition(
              scale: new Tween<double>(begin: 0.0, end: 1.0,).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.00, 0.50, curve: Curves.linear),
                ),
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.5, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.50, 1.00, curve: Curves.linear),
                  ),
                ),
                child: child,
              ),
            );
          }
      );
}
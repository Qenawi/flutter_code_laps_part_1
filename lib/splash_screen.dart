import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_laps_part_1/views/home_screen.dart';
import 'package:flutter_code_laps_part_1/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/my_prefs.dart';

final _splash_Time = 2;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: _splash_Time);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: Text("Splash Text")),
    );
  }

  void navigationPage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool res= preferences.getBool("islogged")??false;
    _navigate(res);
  }
  _navigate(bool log) {
    if (log) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.home_screen);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    }
  }
}

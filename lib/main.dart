import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_laps_part_1/common/my_prefs.dart';
import 'package:flutter_code_laps_part_1/views/meetings_room.dart';
import 'package:flutter_code_laps_part_1/views/pick_users.dart';
import 'common/fcm.dart';
import 'views/home_screen.dart';
import 'splash_screen.dart';
import 'views/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }

}



class _MyApp extends State<MyApp>{
  final FirebaseMessaging _fcm = FirebaseMessaging();
   StreamSubscription iosSubscription;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.white),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        HomeScreen.home_screen: (BuildContext context) => new HomeScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        PickUser.routeName: (context) => PickUser(),
        Meeting_rooms.routeName: (context) => Meeting_rooms()
      },
    );
  }
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS)
    {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Ok'),
                onPressed: () =>{},
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }
  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
     save("FireBaseToken", fcmToken);
    }
  }

}
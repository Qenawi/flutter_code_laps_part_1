import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_code_laps_part_1/common/my_prefs.dart';
import 'package:flutter_code_laps_part_1/common/network_layer.dart';
import 'package:flutter_code_laps_part_1/views/meetings_room.dart';
import 'package:flutter_code_laps_part_1/views/pick_users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  static const home_screen = "/homescreen";

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String uname = "";
  String fname = "";
  String job = "";
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
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
                onPressed: () => {},
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
    get_profile_data();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Center(
                          child: Text("Your Data",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Text("UserName ${uname}",
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Text("Full name ${fname}",
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Text("Title ${job}",
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      Center(
                          child: RaisedButton(
                        onPressed: () => _logout(),
                        child: Text("LogOut"),
                      ))
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 12,
                    top: 12,
                    bottom: 12,
                  ),
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 20.0)),
              SizedBox(height: 35),
              Center(
                  child: RaisedButton(
                color: Colors.orangeAccent,
                onPressed: () => _openDetails(),
                child: Text("Show Meetings"),
              ))
            ],
          )),
    );
  }

  _showSnackBar(String txt) {
    final snackBar = SnackBar(content: Text(txt));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _logout() {
    _showSnackBar("Logging you Out ....");
    Map<String, dynamic> data = {"Username": uname};
    final dio = Dio(); // Provide a dio instance
    final client = RestClient(dio);
    client
        .m_log_out(data)
        .then((it) => _handleLoginResult(it))
        .catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          // Here's the sample to get the failed response error code and message
          _handleLoginFail(obj as DioError);
          break;
        default:
      }
    });
  }

  _handleLoginResult(String data) {
    clearCache();
    _showSnackBar("Logged_Out");
    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }

  _openDetails() {
    Navigator.of(context).pushNamed(Meeting_rooms.routeName);
  }

  _handleLoginFail(DioError data) {
    _showSnackBar("Faild to LogOut Due to ${data.message}");
  }

  void get_profile_data() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString("funame") ?? "";
    String ftitle = preferences.getString("fjop_titile") ?? "";
    String full_namex = preferences.getString("ffullname") ?? "";

    setState(() {
      uname = name;
      job = ftitle;
      fname = full_namex;
    });
  }
}

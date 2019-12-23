import 'package:flutter/material.dart';
import 'package:flutter_code_laps_part_1/common/my_prefs.dart';
import 'package:flutter_code_laps_part_1/common/network_layer.dart';
import 'package:flutter_code_laps_part_1/data/login_response.dart';
import 'package:flutter_code_laps_part_1/views/register.dart';
import 'package:flutter_code_laps_part_1/widget/text_field.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefix0;

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  static final routeName = "/login_page";

  @override
  _LoginState createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  static final String _progress_msg = "Logging you in";

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr?.style(message: _progress_msg);
  }

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final logger = Logger();
  ProgressDialog pr;

  _buildFormAndLogo(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0, width: double.infinity),
            Center(
              child: Text('My Meetings',
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.black, fontSize: 25)),
            ),
            SizedBox(height: 45.0),
            Text('Login Or Create Account',
                style: Theme
                    .of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Colors.black, fontSize: 20)),
            buildTextFied(context, 'Email', email, false),
            buildTextFied(context, 'Password', password, true),
            SizedBox(height: 30.0),
            Center(
              child: OutlineButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child:
                  Text('LOGIN', style: Theme
                      .of(context)
                      .textTheme
                      .body1),
                ),
                onPressed: () {
                  if (!_validate_login()) {
                    _showSnackBar("pleas type your mail and password");
                    return;
                  }
                  pr?.show();
                  var token = getToken().then((it) =>_login(it));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The scaffold does not resize and thus the clipper stays beautify
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Text(
          "Register",
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(fontSize: 11, color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => SignUpPage()),
          );
        },
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight,
                  minHeight: constraints.maxHeight,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildFormAndLogo(context),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: FlatButton(
                        onPressed: () => _showDialog("Terms of use", "Todo "),
                        child: Text("Terms of use"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

//------------
  _handleLoginResult(LoginResponse data) {
    pr?.dismiss();
    cacheLogin(data);
    _showSnackBar("Welcome ${data.full_name}");
    Navigator.of(context).pushReplacementNamed(HomeScreen.home_screen);

  }
  _handleLoginFail(DioError data) {
    pr?.hide();
    _showSnackBar("Faild to login Due to ${data.message}");
  }

  _login(String token) {
    Map<String, dynamic> data = {
      "Username": email.text,
      "Password": password.text,
      "Note_ID": token
    };
    final dio = Dio(); // Provide a dio instance
    final client = RestClient(dio);
    client
        .m_login(data)
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


  _showSnackBar(String txt) {
    final snackBar = SnackBar(content: Text(txt));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  bool _validate_login() {
    return email.text.isNotEmpty && password.text.isNotEmpty;
  }

  _showDialog(String title, String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

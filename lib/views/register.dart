import 'package:flutter/material.dart';
import 'package:flutter_code_laps_part_1/common/my_prefs.dart';
import 'package:flutter_code_laps_part_1/data/login_response.dart';
import 'package:flutter_code_laps_part_1/widget/text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_code_laps_part_1/common/network_layer.dart';

import 'package:progress_dialog/progress_dialog.dart';

import 'home_screen.dart';

class SignUpPage extends StatefulWidget
{
  @override
  _SignUpState createState() {
    return new _SignUpState();
  }
}
class _SignUpState extends State<SignUpPage> {
  static final String _progress_msg = "Creating your account";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final logger = Logger();
  ProgressDialog pr;
  TextEditingController nameC = new TextEditingController();
  TextEditingController usernameC = new TextEditingController();
  TextEditingController passwordC = new TextEditingController();
  TextEditingController positionC = new TextEditingController();
  var phoneC = "";

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr?.style(message: _progress_msg);
  }

  _buildmain(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0, width: double.infinity),
            Center(
              child: Text('Create Account',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.black, fontSize: 25)),
            ),
            buildTextFied(context, 'FullName', nameC, false),
            buildTextFied(context, 'Username', usernameC, false),
            buildTextFied(context, 'Password', passwordC, true),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: InternationalPhoneNumberInput(
                onInputChanged: onPhoneNumberChanged,
                shouldParse: true,
                initialCountry2LetterCode: 'EG',
                hintText: '(010)99425083',
                inputBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
            ),
            buildTextFied(context, 'WorkPosition', positionC, false),
            SizedBox(height: 12.0),
            Center(
              child: OutlineButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text('Register',
                      style: Theme.of(context).textTheme.body1),
                ),
                onPressed: () {
                  if (!_register_validate()) {
                    _showSnackBar("pleas type your  data correctly");
                    return;
                  }
                  pr?.show();
                  getToken().then((it)=>_register(it));
                }, //on pressed
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight,
                  minHeight: constraints.maxHeight,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildmain(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void onPhoneNumberChanged(PhoneNumber phoneNumber) {
    phoneC = phoneNumber.phoneNumber;
  }
  bool _register_validate() {
    return phoneC.isNotEmpty &&
        passwordC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        usernameC.text.isNotEmpty &&
        positionC.text.isNotEmpty;
  }

  _handleLoginResult(LoginResponse data) {
    pr?.dismiss();
    _showSnackBar("Welcome ${data.full_name}");
    cacheLogin(data);
    Navigator.of(context).pushReplacementNamed(HomeScreen.home_screen);
  }

  _handleLoginFail(DioError data) {
    pr?.hide();
    _showSnackBar("Faild to login Due to ${data.message}");
  }

  _showSnackBar(String txt)
  {
    final snackBar = SnackBar(content: Text(txt));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  _register(String token){
    Map<String, dynamic> data = {
      "Username": usernameC.text,
      "Password": passwordC.text,
      "Name": nameC.text,
      "PhoneNumber": phoneC,
      "Position": positionC.text,
      "Note_ID": token
    };
    final dio = Dio(); // Provide a dio instance
    final client = RestClient(dio);
    client
        .m_register(data)
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
}

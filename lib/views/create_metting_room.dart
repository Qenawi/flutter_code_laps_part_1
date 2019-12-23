import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_laps_part_1/common/my_prefs.dart';
import 'package:flutter_code_laps_part_1/data/room_data.dart';
import 'package:flutter_code_laps_part_1/data/user_list_response.dart';
import 'package:flutter_code_laps_part_1/widget/text_field.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_code_laps_part_1/common/network_layer.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CreateMeeting extends StatefulWidget {
  final List<UserListResponse> data;

  CreateMeeting({Key key, @required this.data}) : super(key: key);

  @override
  _CreateMeeting createState() {
    return new _CreateMeeting(data);
  }
}

class _CreateMeeting extends State<CreateMeeting> {
  final List<UserListResponse> passed_daata;

  _CreateMeeting(this.passed_daata);

  static final String _progress_msg = "Creating your meeting";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final logger = Logger();
  ProgressDialog pr;
  TextEditingController nameC = new TextEditingController();
  TextEditingController supjectC = new TextEditingController();
  TextEditingController addressC = new TextEditingController();
  TextEditingController LocationC = new TextEditingController();
  TextEditingController periortyC = new TextEditingController();
  var dateC = "Pick Date";
  var timeC = "Pick time";
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr?.style(
        message: _progress_msg,
        messageTextStyle: TextStyle(
          fontSize: 13,
        ));
  }
  @override
_buildmain(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0, width: double.infinity),
            Center(
              child: Text('Create Meetting',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.black, fontSize: 25)),
            ),
            buildTextFied(context, 'Title', nameC, false),
            buildTextFied(context, 'pirority{High-Low}', periortyC, false),
            buildTextFied(context, 'Address', addressC, false),
            buildTextFied(context, 'Supject', supjectC, false),
            SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                SizedBox(width: 12.0),
                OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12.0),
                    child: Text('setDate',
                        style: Theme.of(context).textTheme.body1),
                  ),
                  onPressed: () {
                    showDate(context);
                  }, //on pressed
                ),
                SizedBox(width: 20.0),
                Text(dateC)
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                SizedBox(width: 12.0),
                OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12.0),
                    child: Text('setTime',
                        style: Theme.of(context).textTheme.body1),
                  ),
                  onPressed: () {
                    showTime(context);
                  }, //on pressed
                ),
                SizedBox(width: 20.0),
                Text(timeC)
              ],
            ),
            SizedBox(height: 30.0),
            Center(
              child: OutlineButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text('CreateRoom',
                      style: Theme.of(context).textTheme.body1),
                ),
                onPressed: () {
                  if (!_validate()) {
                    _showSnackBar("pleas type your data in Right way");
                    return;
                  }
                  _create_meeting();
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

  bool _validate() {
    return nameC.text.isNotEmpty &&
        supjectC.text.isNotEmpty &&
        addressC.text.isNotEmpty &&
        periortyC.text.isNotEmpty &&
        (periortyC.text == "High" || periortyC.text == "Low");
  }

  showDate(BuildContext context) {
    Future<DateTime> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    selectedDate.then((time) => _update_state(time));
  }

  _update_state(DateTime date) {
    setState(() {
      var d = todayDate(date);
      if (d.isNotEmpty && d.length > 2) dateC = d;
    });
  }

  _update_state2(TimeOfDay date) {
    setState(() {
      var d = formatTimeOfDay(date);
      if (d.isNotEmpty && d.length > 2) timeC = d;
    });
  }

  showTime(BuildContext context) {
    Future<TimeOfDay> selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    selectedTime.then((f) => _update_state2(f));
  }

  _handleresult(Create_room_Response data) {
    pr.hide();
    save("should_update_meetings", true);
    _showSnackBar("Created ${data.uname}");
    Navigator.pop(context);
  }

  _handleLoginFail(DioError data) {
    pr.hide();
    _showSnackBar("Faild to Create Meeting Due to ${data.message}");
  }

  _showSnackBar(String txt) {
    final snackBar = SnackBar(content: Text(txt));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _create_meeting() {
    pr?.show();
    var names = passed_daata.map((f) => f.data.user_name).toList();

    var je = json.encode(names);
    Map<String, dynamic> data2 = {
      "title": nameC.text,
      "date": dateC,
      "time": timeC,
      "location_address": addressC.text,
      "location_lat": "1.0",
      "location_long": "1.0",
      "subject": supjectC.text,
      "priority": periortyC.text,
      "username": names
    };
    print(data2);
    final dio = Dio(); // Provide a dio instance
    final client = RestClient(dio);
    client
        .m_create_room(data2)
        .then((it) => _handleresult(it))
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

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_code_laps_part_1/common/network_layer.dart';
import 'package:flutter_code_laps_part_1/data/user_list_response.dart';
import 'package:flutter_code_laps_part_1/widget/text_field.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:dio/dio.dart';

import 'create_metting_room.dart';

class PickUser extends StatefulWidget {
  static final routeName = "/pick_users";

  @override
  State<StatefulWidget> createState() {
    return new _PickUserState();
  }
}

class _PickUserState extends State<PickUser> {
  TextEditingController meetingNameC = new TextEditingController();
  TextEditingController locationC = new TextEditingController();
  TextEditingController subjectC = new TextEditingController();

  static final String _progress_msg = "Fetching userlist";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final logger = Logger();
  ProgressDialog pr;
  List<UserListResponse> _suggestions = List();
  HashMap<int, UserListResponse> _sent = HashMap();
  final Set<int> _saved = Set<int>(); // Add this line.
  final TextStyle _biggerFont = TextStyle(fontSize: 15.0);

  //-----------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr?.style(
        message: _progress_msg,
        messageTextStyle: TextStyle(
          fontSize: 13,
        ));
    SchedulerBinding.instance.addPostFrameCallback((f) => _getUserList());

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Select user/s From List'),
        actions: <Widget>[
          // Add 3 lines from here...
          IconButton(
              icon: Icon(Icons.send), onPressed: () => navigateToCreate()),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return _suggestions.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(16),
            // The itemBuilder callback is called once per suggested
            // word pairing, and places each suggestion into a ListTile
            // row. For even rows, the function adds a ListTile row for
            // the word pairing. For odd rows, the function adds a
            // Divider widget to visually separate the entries. Note that
            // the divider may be difficult to see on smaller devices.
            itemBuilder: (BuildContext _context, int i) {
              // Add a one-pixel-high divider widget before each row
              // in the ListView
              int index = i;
              /*todo Logic*/
              return _buildRow(_suggestions[index]);
            },
            itemCount: _suggestions.length,
          )
        : Center(
            child: Text("No Users To Add "),
          );
  }

  Widget _buildRow(UserListResponse data) {
    _onChange() {}
    final bool alreadySaved = _saved.contains(data.id);
    return ListTile(
      title: Text(
        data.data.name,
        style: _biggerFont,
      ),
      trailing:
          Checkbox(value: alreadySaved ? true : false, onChanged: _onChange()),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(data.id);
            _sent.remove(data.id);
          } else {
            _saved.add(data.id);
            _sent[data.id] = data;
          }
        });
      }, // ... to here.
    );
  }

  navigateToCreate() {
    List<UserListResponse> bundled = List();
    _sent.forEach((k, v) => bundled.add(v));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMeeting(
          data: bundled,
        ),
      ),
    );
  }

  //--------------------
  _getUserList() {
    pr?.show();
    final dio = Dio(); // Provide a dio instance
    final client = RestClient(dio);
    client
        .m_user_list()
        .then((it) => _handelUserListsResult(it))
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

  _handelUserListsResult(String data) {
    pr?.hide();
    logger.v("raw-> $data");
    try {
      var je = json.decode(data) as List;
      var re = je.map((tagJson) => UserListResponse.fromJson(tagJson)).toList();
      setState(() {
        pr?.hide();
        _suggestions.addAll(re);
      });
      //   _suggestions.addAll(iterable)
    } catch (error) {
      _handleLoginFail(DioError(error: error));
    }
  }

  _handleLoginFail(DioError data) {
    pr?.hide();
    _showSnackBar("Faild to login Due to ");
  }

  _showSnackBar(String txt) {
    final snackBar = SnackBar(content: Text(txt));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

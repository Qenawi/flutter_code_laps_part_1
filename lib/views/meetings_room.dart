import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_code_laps_part_1/common/my_prefs.dart';
import 'package:flutter_code_laps_part_1/common/my_prefs.dart' as prefix0;
import 'package:flutter_code_laps_part_1/common/network_layer.dart';
import 'package:flutter_code_laps_part_1/data/UserRoomsResponse.dart';
import 'package:flutter_code_laps_part_1/data/user_list_response.dart';
import 'package:flutter_code_laps_part_1/views/pick_users.dart';
import 'package:flutter_code_laps_part_1/widget/text_field.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_metting_room.dart';

class Meeting_rooms extends StatefulWidget {
  static final routeName = "/meeting_room";

  @override
  State<StatefulWidget> createState() {
    return new _Meeting_rooms();
  }
}

class _Meeting_rooms extends State<Meeting_rooms> {
  static final String _progress_msg = "Fetching user_rooms";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  final logger = Logger();
  ProgressDialog pr;
  List<UserRoomResponse> _suggestions = List();
  HashMap<int, _type_x> state = HashMap();
  final TextStyle _biggerFont = TextStyle(fontSize: 15.0);

  //-----------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((f) => _getUserList());
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
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr?.style(
        message: _progress_msg,
        messageTextStyle: TextStyle(
          fontSize: 13,
        ));
  }

  @override
  Widget build(BuildContext mainCtx) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('My Meetings'),
        actions: <Widget>[
          // Add 3 lines from here...
          IconButton(
              icon: Icon(Icons.add), onPressed: () => navigateToCreate()),
          IconButton(icon: Icon(Icons.refresh), onPressed: () => _getUserList())
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return _suggestions.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(5),
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
            child: Text("create new meeting"),
          );
  }

  Widget _buildRow(UserRoomResponse data) {
    var s = state[data.id] ?? _type_x(false, "lodding");
    var is_after = s.is_after;
    var str = s.msg;
    _onChange() {}
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  onPressed: () => _newTaskModalBottomSheet(context),
                  icon: Icon(Icons.menu)),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Text(data.data.title,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Center(
                  child: Text("Date ${data.data.date} at ${data.data.time} ",
                      style: TextStyle(fontSize: 11, color: Colors.green)),
                ),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Text("Supject: ${data.data.subject}"),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Text("Location: ${data.data.location_address}"),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Text(
              str,
              style: TextStyle(color: is_after ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Colors.white,
    );
  }

  navigateToCreate() async {
    Navigator.of(context).pushNamed(PickUser.routeName);
  }

  _getUserList() async {
    //   pr?.show();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uname = preferences.getString("funame") ?? "";
    _showSnackBar("loadding");
    Map<String, dynamic> data = {"Username": uname};
    final dio = Dio(); // Provide a dio instance
    final client = RestClient(dio);
    client
        .m_user_meetings(data)
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
      var re = je.map((tagJson) => UserRoomResponse.fromJson(tagJson)).toList();
      var nr = HashMap<int, _type_x>();
      add(int id, _type_x l) {
        nr[id] = l;
        print("${nr.toString()}  ->");
      }

      re.forEach((l) => let_date_x(l.data.date, (m) => add(l.id, m)));
      setState(() {
        save("should_update_meetings", false);
        state.clear();
        state.addAll(nr);
        print(nr.toString());
        _suggestions.clear();
        _suggestions.addAll(re);
        print("set_state");
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

  let_date_x(String date, ValueSetter<_type_x> ret) async {
    var now = new DateTime.now();
    var newDateTimeObj2 = DateFormat("yyyy-MM-dd").parse(date);
    var res = newDateTimeObj2.isAfter(now);
    var def = newDateTimeObj2.difference(now);
    var st = "--";
    if (def.inHours.abs() >= 24) {
      int dayes = def.inHours.abs() ~/ 24;
      var houres = def.inHours.abs() % 24;
      st = "Happening in $dayes Dayes and $houres Houres";
    } else {
      st = "Happening in  ${def.inHours.abs()} Houres";
    }
    print("$res  $st");
    if (res != true) {
      st = "Fineshd";
    }
    ret(_type_x(res, st));
  }
}

_get_meeting_user(BuildContext context) {
  Navigator.pop(context);
  List<String> ulist = List();
  for (int i = 0; i < 20; i++) ulist.add("dummy_user $i");
  _newUser_listBottomSheet(context, ulist);
}

void _newTaskModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.keyboard_capslock),
                  title: new Text('Send Notification'),
                  onTap: () => Navigator.pop(context)),
              new ListTile(
                leading: new Icon(Icons.people),
                title: new Text('ShowUserList'),
                onTap: () => _get_meeting_user(context),
              ),
            ],
          ),
        );
      });
}

void _newUser_listBottomSheet(context, List<String> ulist) {
  Widget _buildRow(String data) {
    _onChange() {}
    return ListTile(
      title: Text(
        data,
        style: TextStyle(fontSize: 14),
      ),
      leading: Icon(Icons.person),
      trailing: Text("Bla Bla"),
      // ... to here.
    );
  }

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
            child: ListView.builder(
                itemCount: ulist.length + 1,
                itemBuilder: (BuildContext _context, int i) {
                        if (i == 0)
                         return Center(
                         child: Container(
                         child: Text("User List",style: TextStyle(fontWeight: FontWeight.bold
                         ,fontSize: 15
                         ),),
                         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20) ,
                        )
                        );
                  else
                    return _buildRow(ulist[i - 1]);
                }));
      });
}

class _type_x {
  bool is_after;

  String msg;

  _type_x(this.is_after, this.msg);
}

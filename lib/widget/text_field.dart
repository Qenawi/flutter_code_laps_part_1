import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
Widget buildTextFied(BuildContext context, String labelText,
    TextEditingController controller, bool isPassowrd) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
    child: Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.black),
      child: TextField(
        obscureText: isPassowrd,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    ),
  );
}
BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(),
  );
}

String todayDate(DateTime time) {
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedTime = DateFormat('hh:mm:ss').format(time);
  String formattedDate = formatter.format(time);
  return formattedDate;
}

String formatTimeOfDay(TimeOfDay tod) {
  if (tod == null) return " ";
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  // final format = DateFormat.jm(); //"6:00 AM"
  var d = DateFormat("HH:mm").format(dt);
  return d;
}

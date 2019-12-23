import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProgress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("xxxx",
          style:
          Theme.of(context).textTheme.body1.copyWith(color: Colors.orange)),
    );
  }}

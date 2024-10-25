import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  final String id;
  const Mainscreen(this.id, {super.key});

  @override
  MyRecordState createState() => MyRecordState();
}

class MyRecordState extends State<Mainscreen> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.id); // Here you direct access using widget
  }
}

import 'package:flutter/material.dart';

class AssignToRoomate extends StatefulWidget {
  @override
  _AssignToRoomateState createState() => _AssignToRoomateState();
}

class _AssignToRoomateState extends State<AssignToRoomate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign To..."),
        centerTitle: true,
      ),
    );
  }
}

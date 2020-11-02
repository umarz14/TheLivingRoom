
import 'package:flutter/material.dart';

class household extends StatefulWidget {
  @override
  _householdstate createState() => _householdstate();
}

class _householdstate extends State<household> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[800],
        child: Center(

          child: Text('Roommates'),
        ),
      ),
    );
  }
}

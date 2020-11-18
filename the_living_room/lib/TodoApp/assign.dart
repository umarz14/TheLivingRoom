import 'package:flutter/material.dart';
import 'package:the_living_room/database/databse.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<QuerySnapshot>(context);
    //print(users.docs);
    for (var doc in users.docs){
      print(doc.data());
    }
    return Container();
  }
}


class AssignToRoomate extends StatefulWidget {
  @override
  _AssignToRoomateState createState() => _AssignToRoomateState();
}

class _AssignToRoomateState extends State<AssignToRoomate> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Assign To..."),
          centerTitle: true,
        ),
        body: UserList(),
      ),
    );
  }
}

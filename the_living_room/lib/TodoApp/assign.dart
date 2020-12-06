import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/Classes.dart';
import 'package:the_living_room/TodoApp/Cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemberList extends StatelessWidget {


  final id = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('household').doc(id).collection('member');
    return StreamBuilder<QuerySnapshot>(
      stream: tasks.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new MemberTile(
              member: Member(name: document.data()['name']),
            );
          }).toList(),
        );
      },
    );
  }
}


class AssignToRoomate extends StatefulWidget {
  final ToDoItem data;
  AssignToRoomate({this.data});

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
      body: MemberList(),
    );
  }
}

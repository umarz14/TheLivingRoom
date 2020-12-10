import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/Classes.dart';
import 'package:the_living_room/TodoApp/Cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemberList extends StatelessWidget {

  final String todoId;
  MemberList({this.todoId});
  //MemberList({Key key, @required this.todoId}) : super(key: key);

  final id = FirebaseAuth.instance.currentUser.uid;
  final lol = 'RRpXs6hUf2e7nXlNp5I0Az0ci9r1';
  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('household').doc(lol).collection('member');
    return StreamBuilder<QuerySnapshot>(
      stream: tasks.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Text("Loading");
        }
        else {
          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              print(document.data()['name']);
                return new MemberTile(
                  member: Member(name: document.data()['name'], taskId: todoId),
                );

            }).toList(),
          );
        }
      },
    );
  }
}


class AssignToRoomate extends StatefulWidget {

  final ToDoItem todo;
  AssignToRoomate({Key key, @required this.todo}) : super(key: key);

  _AssignToRoomateState createState() => _AssignToRoomateState();
}

class _AssignToRoomateState extends State<AssignToRoomate> {
  CollectionReference tasks = FirebaseFirestore.instance.collection('household').doc('RRpXs6hUf2e7nXlNp5I0Az0ci9r1').collection('member');
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign To..."),
        centerTitle: true,
      ),
      body: MemberList(todoId: widget.todo.id),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          String hey = widget.todo.id;
          print("hey is = $hey");
        },
      ),
    );
  }
}

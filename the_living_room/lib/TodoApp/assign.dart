import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/Classes.dart';
import 'package:the_living_room/TodoApp/Cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberList extends StatelessWidget {

  final String todoId;
  final String hid;
  MemberList({this.todoId, this.hid});

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('household').doc(hid).collection('member');
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
                  member: Member(name: document.data()['name'], taskId: todoId, hid: hid),
                );

            }).toList(),
          );
        }
      },
    );
  }
}


class AssignToRoommate extends StatefulWidget {

  final ToDoItem todo;
  AssignToRoommate({Key key, @required this.todo}) : super(key: key);

  @override
  _AssignToRoommateState createState() => _AssignToRoommateState();
}

class _AssignToRoommateState extends State<AssignToRoommate> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign To..."),
        centerTitle: true,
      ),
      body: MemberList(todoId: widget.todo.id, hid: widget.todo.hid),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          String hey = widget.todo.id;
          print("hey is = $hey");
        },
      ),
    );
  }
}

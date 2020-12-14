import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:the_living_room/TodoApp/Cards.dart';
import 'package:the_living_room/TodoApp/Classes.dart';
import 'package:the_living_room/TodoApp/addTask.dart';
import 'package:flutter/cupertino.dart';

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToDoList(),
    );
  }
}

class TaskList extends StatefulWidget {
  final String hid;
  TaskList({this.hid});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {

  @override

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:FirebaseFirestore.instance.collection('household').doc(widget.hid).collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Text("Loading");
        }
        else{
        return new ListView(
          children: snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
            return new ToDoCard(
              toDoItem: ToDoItem(todo:document.data()['task'], creator: document.data()['creator'], delegated:document.data()['delegated'], id:document.id, hid: widget.hid),
              delete: () {
                FirebaseFirestore.instance.collection('household').doc(widget.hid).collection('tasks').doc(document.id)
                    .delete();
              },
              hid: widget.hid,
            );
          }).toList(),
        );
}
        },
    );
  }
}// End of Task List




class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool loading = true;
  String houseID;

  String getHouseHold()
  {
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    //print('user id {$id}');

    databaseReference.collection("users").doc(currentUser.uid).get().then((value){
      houseID = value.data()['household'];
      setState((){ loading = false; });
    });

    // print('house id in getHouseHold {$houseID}');

    return houseID;
  }

  @override

  Widget build(BuildContext context) {

    String householdID;
    householdID = getHouseHold();//does not work here
    if(loading) return CircularProgressIndicator();
    print('house id in build {$householdID}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
      ),
      body: TaskList(hid: householdID),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PushAddToDoScreen(houseId: householdID,))
          );
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  } // End of build
}

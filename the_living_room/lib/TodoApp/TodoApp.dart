import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/*import 'package:the_living_room/TodoApp/to_do_card.dart';
import 'package:the_living_room/TodoApp/todo.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:the_living_room/household.dart';
import 'package:cloud_firestore/cloud_firestore.dart';*/
import 'package:firebase_auth/firebase_auth.dart';

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: ToDoList(),
    );
  }
}

void getHouse() {
  final User currentUser = FirebaseAuth.instance.currentUser;
  final id = FirebaseAuth.instance.currentUser.uid;
  print(id);

  print('after this');
  final firestoreInstance = FirebaseFirestore.instance
    .collection('household')
    .doc(id)
    .collection('tasks')
    .add({
      "creator": "james",
      'delegated': 'apples',
      'task': 'is it in the database'
    }
    );
  //.doc('test')
    /*.get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Document exists on the database');
    }
  });*/
  //return id;
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
      ),
      body: Text("yellow"),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getHouse();
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  } // End of build
}



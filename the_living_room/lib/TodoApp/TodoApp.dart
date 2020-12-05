import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_living_room/database/database.dart';
import 'package:provider/provider.dart';
import 'package:the_living_room/household.dart';

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: ToDoList(),
    );
  }
}

void getHouseId() {
  // This is the uid for their User Document
  final id = FirebaseAuth.instance.currentUser.uid;

  FirebaseFirestore.instance
    .collection('users')
    .doc(id)
    .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Document exists on the database');
      Map<String, dynamic> data = documentSnapshot.data();
      print("household: ${data['household']}");
    }
  });
}

class TaskList extends StatelessWidget {

  final id = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('household').doc(id).collection('tasks');
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
            return new ListTile(
              title: new Text(document.data()['task']),
              subtitle: new Text(document.data()['creator']),
            );
          }).toList(),
        );
      },
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final id = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
          centerTitle: true,
        ),
        body: TaskList(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            getHouseId();
          },
          tooltip: 'Add Task',
          child: Icon(Icons.add),
        ),
      ),
    );
  } // End of build
}



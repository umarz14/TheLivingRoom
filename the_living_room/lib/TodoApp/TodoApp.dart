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

class TaskList extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('household').doc('RRpXs6hUf2e7nXlNp5I0Az0ci9r1').collection('tasks');
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
            return new ToDoCard(
              toDoItem: ToDoItem(todo:document.data()['task'], creator: document.data()['creator'], delegated:document.data()['delegated'], id:document.id),
              delete: () {
                tasks.doc(document.id)
                    .delete();
              },
            );
          }).toList(),
        );
      },
    );
  }
}// End of Task List


class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {

  Future<String> getData() async{

    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;

    String houseId = await databaseReference.collection("users").doc(currentUser.uid).get().then((value){
      return value.data()['household'];
    });
    print('$houseId');
    return houseId;

  }
/*
  @override
  void initState(){
  super.initState();
  getData();
  }

 */

  @override
  Widget build(BuildContext context) {
    print("apples");
    print(getData());
    var householdID = getData();
    print('house id = $householdID');

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
      ),
      body: TaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PushAddToDoScreen())
          );
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  } // End of build
}

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_living_room/TodoApp/Cards.dart';
import 'package:the_living_room/TodoApp/Classes.dart';
import 'package:the_living_room/TodoApp/addTask.dart';


class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: ToDoList(),
    );
  }
}
/*
Future<User> _fetchUserInfo(String id) async {
  User fetchedUser;
  var snapshot = await FirebaseFirestore.instance
      .collection('user')
      .doc(id)
      .get();
  return User(snapshot);
}
*/

/*
foo() async {
  final id = FirebaseAuth.instance.currentUser.uid;
  final user = await getdata1(id);
  return await getdata1(id);

}

getdata1(String id) async{
  // This is the uid for their User Document
  String hid = '';
  final id = FirebaseAuth.instance.currentUser.uid;
  print(id);

  await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      //print('Document exists on the database');
      Map<String, dynamic> data = documentSnapshot.data();
      //print("{$data['household']}");
      return (data["household"].toString());
      print("hid = $hid");
    }});
  return hid;
}

*/

/*
final String _collection = 'users';
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

getData() async {
  return await _fireStore.collection(_collection).doc('h5e1Q7DKMfPwpccjfYuxSgfOF0W2').get();
}
getDat() {
  getData().then((val) {
    if (val.documents.length > 0) {
      print(val.documents[0].data["household"]);
    }
    else {
      print("Not Found");
    }
  });
}

 */

class TaskList extends StatelessWidget {

  final id = FirebaseAuth.instance.currentUser.uid;
  //final hid  = foo();
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
}


class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final id = FirebaseAuth.instance.currentUser.uid;
  //String hid = foo();
  @override
  Widget build(BuildContext context) {
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

        //String hello = "apple";
        //print('household $hello');
        //hello = getHouseId();
        //print('household $hello');
        //String y = getdata1();
        //print("pritint outisde the function $y");
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  } // End of build
}


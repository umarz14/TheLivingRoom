import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

void addTodoItem(String tdi) {


  //Get the name of the creator
  String nameOfCreator = 'me';
  final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    nameOfCreator = currentUser.displayName;
  } // Enf of if
  else{
    nameOfCreator = "user = null";
  } // End of else

  // This add task to database
  FirebaseFirestore.instance
      .collection('household')
      .doc('RRpXs6hUf2e7nXlNp5I0Az0ci9r1')
      .collection('tasks')
      .add({
    "creator": nameOfCreator,
    'delegated': nameOfCreator,
    'task': tdi
  }
  );

} // End of addTodoItem


// This function creates a new screen in top of our current screen where
// one can add items
class PushAddToDoScreen extends StatefulWidget {
  @override
  _PushAddToDoScreenState createState() => _PushAddToDoScreenState();
}

class _PushAddToDoScreenState extends State<PushAddToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task"),
        centerTitle: true,
      ),
      body: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2)
          ),
          hintText: 'What Is The New Task?',
        ),
        onSubmitted: (toDoTask){
          addTodoItem(toDoTask);
          Navigator.pop(context);
        },
      ),
    );
  }
}
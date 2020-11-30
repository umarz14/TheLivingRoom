import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_living_room/TodoApp/to_do_card.dart';
import 'package:the_living_room/TodoApp/todo.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:the_living_room/database/databse.dart';

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Variables
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();

  //List<String> tdl = List<String>(); // TO DO LIST
  List<ToDoItem> tdl = [
    ToDoItem(todo: 'go to store', creator: 'me'),
    ToDoItem(todo: 'say hello world', creator:'me'),
    ToDoItem(todo: 'update list', creator: 'me')
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  } // End of Dispose

  void addTodoItem(String tdi) {
    String nameOfCreator = 'me';
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      nameOfCreator = currentUser.displayName;
    } // Enf of if
    else{
      nameOfCreator = "user = null";
    } // End of else

    setState(() {
      tdl.add(ToDoItem(todo: tdi, creator: nameOfCreator));
    });
  } // End of addTodoItem

  // This function creates a new screen in top of our current screen where
  // one can add items
  void pushAddTodoScreen() {
    //push page onto the stack; yes stack literally a a stack
    Navigator.of(context).push(
        // MaterialapageRoute automatically animates a screen entry
        // We will also use this page to a back button to close itself(does itself)
        MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
        ),
        body: Container(
          //padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2)
                ),
                hintText: 'What do you have to do?'),
            onSubmitted: (toDoTask) {
              addTodoItem(toDoTask);
              Navigator.pop(context); // Close the New Task Screen
            },
          ),
        ),
      );
    }));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: tdl.length,
          itemBuilder: (context, index) {
            return ToDoCard(
              toDoItem: tdl[index],
              delete: () {
                setState(() {
                  tdl.remove(tdl[index]);
                });
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: pushAddTodoScreen,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  } // End of build
}


class TaskCloud extends StatefulWidget {
  @override
  _TaskCloudState createState() => _TaskCloudState();
}

class _TaskCloudState extends State<TaskCloud> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().tasks,
      child: Scaffold(
        appBar: AppBar(
          title: Text("TodoCloud"),
          centerTitle: true,
        ),
      body: //TaskList(),
      ),
    );
  }
}

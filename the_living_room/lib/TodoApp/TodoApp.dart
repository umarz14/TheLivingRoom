import 'package:flutter/material.dart';
import 'to_do_card.dart';
import 'todo.dart';

class  ToDoApp extends StatelessWidget {
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
    ToDoItem(todo: 'go to store'),
    ToDoItem(todo: 'say hello world'),
    ToDoItem(todo: 'update list')
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  } // End of Dispose

  void addTodoItem(String tdi) {
    setState(() {
      tdl.add(ToDoItem(todo: tdi));
    });
  } // End of addTodoItem

  // This function creates a new screen in top of our current screen where
  // one can add items
  void pushAddTodoScreen(){
    //push page onto the stack; yes stack literally a a stack
    Navigator.of(context).push(
      // MaterialapageRoute automatically animates a screen entry
      // We will also use this page to a back button to close itself(does itself)
        MaterialPageRoute(
            builder: (context){
              return Scaffold(
                appBar: AppBar(
                  title: Text('New Task'),
                ),
                body: TextField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'What do you have to do?'
                  ),
                  onSubmitted: (toDoTask){
                    addTodoItem(toDoTask);
                    Navigator.pop(context); // Close the New Task Screen
                  },
                ),
              );
            }
        )
    );
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
          itemBuilder: (context, index){
            return ToDoCard(
              toDoItem: tdl[index],
              delete: (){
                setState(() {
                  tdl.remove(tdl[index]);
                });
              },
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pushAddTodoScreen,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  } // End of build
}
import 'package:flutter/material.dart';
import 'todo.dart';
class ToDoCard extends StatelessWidget {

  final ToDoItem toDoItem; // Because this is stateful widget data can not change so we put final
  final Function delete;
  ToDoCard( { this.toDoItem, this.delete } ); // Constructor should be the same as the class

  void assignUser() {
    //push page onto the stack; yes stack literally a a stack
    Navigator.of(context).push(
      // MaterialapageRoute automatically animates a screen entry
      // We will also use this page to a back button to close itself(does itself)
        MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('New Task'),
            ),
            body: TextField(
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'What do you have to do?'),
              onSubmitted: (toDoTask) {
                //addTodoItem(toDoTask);
                Navigator.pop(context); // Close the New Task Screen
              },
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Text(
                  toDoItem.todo,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10, height: 10,),
                FlatButton(
                  color: Colors.green,
                  child: Text('hello'),
                  onPressed: assignUser,
                  textColor: Colors.blue,

                )
              ],
            ),
            SizedBox(height: 6.0),
            Text(
              toDoItem.user
            ),
            FlatButton.icon(
                onPressed: delete,
                icon: Icon(Icons.delete),
                label: Text('delete')
            )
          ],
        ),
      ),
    );
  }
}

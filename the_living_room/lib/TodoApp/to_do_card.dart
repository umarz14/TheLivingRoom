import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/assign.dart';
import 'todo.dart';
class ToDoCard extends StatelessWidget {

  final ToDoItem toDoItem; // Because this is stateful widget data can not change so we put final
  final Function delete;
  ToDoCard( { this.toDoItem, this.delete } ); // Constructor should be the same as the class

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
                  onPressed: AssignToRoomate(),
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

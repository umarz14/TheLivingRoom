import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/assign.dart';
import 'todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
class ToDoCard extends StatefulWidget {

  final ToDoItem toDoItem; // Because this is stateful widget data can not change so we put final
  final Function delete;
  ToDoCard( { this.toDoItem, this.delete } );
  @override
  _ToDoCardState createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {

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
                  widget.toDoItem.todo,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10, height: 10,),
                FlatButton(
                  color: Colors.grey[500],
                  child: Text('Assign'),
                  textColor: Colors.black,
                  onPressed: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AssignToRoomate())
                    );
                  },


                )
              ],
            ),
            SizedBox(height: 6.0),
            Text(
              widget.toDoItem.creator
            ),
            FlatButton.icon(
                onPressed: widget.delete,
                icon: Icon(Icons.delete),
                label: Text('delete')
            )
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<QuerySnapshot>(context);
    print(tasks.docs);
    return Container();
  }
}




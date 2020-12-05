import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/assign.dart';
import 'Classes.dart';

//ToDo Card
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
              toDoItem.creator
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

//Member Card
class MemberTile extends StatelessWidget {

  final Member member;
  MemberTile({this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListTile(
          leading: CircleAvatar( // put user profile pics here later
            radius: 25,
            backgroundColor: Colors.grey,
          ),
          title: Text(member.name),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/assign.dart';
import 'package:the_living_room/TodoApp/Classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Classes.dart';

/*
class InheritedTodo extends InheritedWidget {
  final ToDoItem todo;

  InheritedTodo({this.todo, Widget child}) :super(child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}

 */

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
                ButtonTheme(
                  minWidth: 20,
                  child: FlatButton(
                    color: Colors.grey[500],
                    child: Icon(Icons.assignment_ind),
                    textColor: Colors.black,
                    onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AssignToRoomate(todo: toDoItem)),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10, height: 10,),
                Text(toDoItem.delegated)
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
          trailing: Icon(Icons.add),
          onTap:(){
            final lol = member.taskId;
            print('$lol');
            FirebaseFirestore.instance
                .collection('household')
                .doc('RRpXs6hUf2e7nXlNp5I0Az0ci9r1')
                .collection('tasks')
                .doc(lol)
                .update({'delegated': member.name})
                .then((value) => print("User Updated"))
                .catchError((error) => print("Failed to update user: $error"));
          },
        ),
      ),
    );
  }
}

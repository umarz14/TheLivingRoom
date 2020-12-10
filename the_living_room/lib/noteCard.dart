import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'noteClasses.dart';

class NoteCard extends StatelessWidget {
  Function delete;
  NotesModel note;

  NoteCard( { this.note, this.delete } );

  //format the date and time correctly
  String format(DocumentSnapshot document) {
    DateTime time = (document['Date'].toDate());
    DateFormat formatter = DateFormat.yMd().add_jm();
    String formatted = formatter.format(time);
    return formatted;
  } //format

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              note.title,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.blue,
              ),
            ),
            Text(
              note.note,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            Text(note.now, style: TextStyle(fontSize: 16)),
            Text(note.userName, style: TextStyle(fontSize: 16)),

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
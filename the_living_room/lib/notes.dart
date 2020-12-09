import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add a Note',
      home: NotesList(),
    );
  }
}

/*class NotesModel {
  String title;
  String note;
  String now;
  String userName;

  NotesModel({this.title, this.note, this.now, this.userName});
}*/

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {

  final myController = TextEditingController();
  String houseID;
  bool loading = true;

  //get household ID from user
  String getHouseHold()
  {
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    String id = currentUser.uid;
    //print('user id {$id}');

    databaseReference.collection("users").doc(currentUser.uid).get().then((value){
      houseID = value.data()['household'];
      setState((){ loading = false; });
    });

    //print('house id in getHouseHold {$houseID}');

    return houseID;
  }

  void addNoteItem(String inputTitle, inputNote) async {
    DateTime time = DateTime.now();
    String name = '';
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    final firestoreInstance = FirebaseFirestore.instance;
    String householdID = getHouseHold();
    print('house id in addNoteItem {$householdID}');

    //get display name
    if (currentUser != null) {
      name = currentUser.displayName;
    }
    else {
      name = "user is null";
    }

    //store note in database
    firestoreInstance.collection("household").doc(householdID)
        .collection("notes")
        .add(
        {
          "Date": time,
          "Note": inputNote,
          "Title": inputTitle,
          "User": name
        }
    );
  } // End of addTodoItem

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Missing Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Text field has been left blank'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // This function creates a new screen in top of our current screen where
  // one can add items
  void pushAddNotesScreen() {
    String _title;
    String _note;

    Navigator.of(context).push(
      // MaterialapageRoute automatically animates a screen entry
      // We will also use this page to a back button to close itself(does itself)
        MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('New Note'),
                ),
                body: new Container(
                  child: new Column (
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                            hintText: 'Enter a note title',
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                            hintText: 'Enter a note body',
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              _note = value;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if(_title != null && _note != null){
                                addNoteItem(_title, _note);
                                Navigator.pop(context);
                              }
                              else{
                                _showMyDialog();
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),
                    ]
                  ),
                ),
              );
            }
        )
    );
  }

  //format the date and time correctly
  String format(DocumentSnapshot document) {
    DateTime time = (document['Date'].toDate());
    DateFormat formatter = DateFormat.yMd().add_jm();
    String formatted = formatter.format(time);
    return formatted;
  } //format

  //implement a way to check if current user is document user
  /*void delete(){
    CollectionReference household = FirebaseFirestore.instance.collection('household');
    household
        .doc(document.id)
        .delete()
        .then((value) => print("Note Deleted"))
        .catchError((error) => print("Failed to delete Note: $error"));
  }*/

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              document['Title'],
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.blue,
              ),
            ),
            Text(
              document['Note'],
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            Text(format(document), style: TextStyle(fontSize: 16)),
            Text(document['User'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 6.0),
            //need to implement delete button
            /*FlatButton.icon(
                onPressed: delete,
                icon: Icon(Icons.delete),
                label: Text('delete')
            )*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String householdID;
    householdID = getHouseHold();//does not work here
    if(loading) return CircularProgressIndicator();

      return Scaffold(
        appBar: AppBar(
          title: Text('Notes'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection("household").doc(householdID).collection("notes").orderBy('Date', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Text('Loading...');
              else
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]),
                );
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: pushAddNotesScreen,
          tooltip: 'Add Note',
          child: Icon(Icons.add),
        ),
      );// End of build
  }
}

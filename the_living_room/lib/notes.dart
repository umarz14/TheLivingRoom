import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add a Note',
      home: NotesList(),
    );
  }
}

class NotesModel {
  String title;
  String note;
  String now;

  NotesModel({this.title, this.note, this.now});
}

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  // Variables
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int count = 2;

  List<NotesModel> tdl = [
    NotesModel(title: 'Note 1', note: 'example note', now: ''),
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  } // End of Dispose

  void addNoteItem(String entry) {
    String currentTitle = "Note " + count.toString();
    count = count + 1;
    DateTime time = DateTime.now();
    DateFormat formatter = DateFormat.yMd().add_jm();
    String formatted = formatter.format(time);
    setState(() {
      tdl.add(NotesModel(title: currentTitle, note: entry, now: formatted));
    });
  } // End of addTodoItem

  bool validate(String value){
    if (value.isEmpty) {
      return false;
    }
    else {return true; }
  }

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
            TextButton(
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
  void pushAddTodoScreen(){

    //push page onto the stack; yes stack literally a a stack
    Navigator.of(context).push(
      // MaterialapageRoute automatically animates a screen entry
      // We will also use this page to a back button to close itself(does itself)
        MaterialPageRoute(
            builder: (context){
              return Scaffold(
                appBar: AppBar(
                  title: Text('New Note'),
                ),
                body:

                TextField(

                  decoration:
                  InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'Enter a note',
                  ),
                  onSubmitted: (newnote){
                    bool valid = validate(newnote);
                    if (valid){
                      addNoteItem(newnote);
                    }
                    else{
                      _showMyDialog();
                      pushAddTodoScreen();
                    }
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
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: tdl.length,
          itemBuilder: (context, index){
            return NoteCard(
              aNoteItem: tdl[index],
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
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  } // End of build
}


class NoteCard extends StatelessWidget {

  final NotesModel aNoteItem; // Because this is stateful widget data can not change so we put final
  final Function delete;

  NoteCard( { this.aNoteItem, this.delete} ); // Constructor should be the same as the class

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
              aNoteItem.title,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.blue,
              ),
            ),
            Text(
              aNoteItem.note,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            Text(aNoteItem.now, style: TextStyle(fontSize: 16)),
            SizedBox(height: 6.0),
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

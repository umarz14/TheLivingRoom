import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:path/path.dart' as path;

class Household extends StatefulWidget {
  @override
  _HouseholdState createState() => _HouseholdState();
}

class Upload extends StatefulWidget {
  @override
  _Uploadstate createState() => _Uploadstate();
}

class Roomies extends StatefulWidget {
  @override
  _RoomiesState createState() => _RoomiesState();
}

class _HouseholdState extends State<Household> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              Text('Roommates'),

          RaisedButton(
            child: Text('Documents'),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Upload()),
              );
            },
            color: Colors.cyan,
          ),
              RaisedButton( //menu for adding roommates to the household
                child: Text('Household Members'),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Roomies()),
                  );
                },
                color: Colors.cyan,
              ),
         ],
        ),
      ),
    );
  }
}


class _Uploadstate extends State<Upload> {

  File _image;
  File _imageList;
  //String _uploadedFileURL;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future chooseImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });

     // _uploadedFileURL = path.basename(_image.path);

      //Reference ref = FirebaseStorage.instance.ref('Documents').child(
      //    _uploadedFileURL);
      //UploadTask uploadTask = ref.putFile(_image);
    } //chooseImage

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload a photo"),
      ),
      body: Builder(
        builder: (context) =>
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          child: SizedBox(
                            width: 150.0,
                            height: 300.0,
                            child: (_image != null) ? Image.file(_image)
                                : Image.network(
                                ""
                            ),
                          ),
                        ),
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          child: RaisedButton(
                            child: Text('Upload photo'),
                            onPressed: () {
                              chooseImage();
                            },
                          ),
                        ),
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          child: RaisedButton(
                            child: Text('Back'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.cyan,
                          ),
                        ),
                      ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        child: (_imageList != null) ? Image.file(_imageList)
                            : Image.network(
                            ""
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class _RoomiesState extends State<Roomies> {
  final fb = FirebaseDatabase.instance;
  final databaseReference = FirebaseFirestore.instance;
  final User currentUser = FirebaseAuth.instance.currentUser;
  final myController = TextEditingController();
  final name = "Name";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add roommates"),
        ),
        body: Center(
          child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(name),
                    Flexible(child: TextField(controller: myController)),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    final text = myController.text.toLowerCase();
                    addHouseholdMember(text);
                    Navigator.pop(context);
                  },
                  child: Text("Submit"),
                ),
            RaisedButton(
              child: Text('Back'),
              onPressed: (){
                Navigator.pop(context);
              },
              color: Colors.cyan,
            ),
            ],
          )
        )
    );
  }
}

void addHouseholdMember(String username ) async {
final databaseReference = FirebaseFirestore.instance;
final User currentUser = FirebaseAuth.instance.currentUser;
String houseID;
String userID = await getUID(username);
final id = currentUser.uid; //get ID to set in map
DocumentSnapshot userDoc = await databaseReference.collection('users').doc(id).get();
houseID = userDoc.data()['household']; //get household ID from user document
if(houseID == null){
  houseID = id;
  databaseReference.collection('household').doc(houseID).collection("member").doc(id).set({
    "name": currentUser.displayName
  });
}
/*
DocumentSnapshot idMap = await databaseReference.collection("emailToID").doc("source").get(); //get document which contains map of emails to uids
newUserID = idMap.data()[username]; //grab user id
*/
//future<String> name = asd; heeyyyy
  DocumentSnapshot inviteeDoc = await databaseReference.collection('users').doc(userID).get();
  String inviteeName = inviteeDoc.data()['name']; //get household ID from user document
  databaseReference.collection('household').doc(houseID).collection("member").doc(userID).set({
    "name": inviteeName
  });
  databaseReference.collection("users")
      .doc(userID).update({
    'household': id
  });
//final householdID = await databaseReference.collection("household").doc(houseID).set(member, SetOptions.merge());
}

Future<String> getUID(String email) async {
  final databaseReference = FirebaseFirestore.instance;
  //final User currentUser = FirebaseAuth.instance.currentUser;
  String newUserID;
  String emailMod = email.replaceAll(".","_");
  DocumentSnapshot idMap = await databaseReference.collection("emailToID").doc("source").get(); //get document which contains map of emails to uids
  newUserID = idMap.data()[emailMod]; //grab user id
  return newUserID;
}
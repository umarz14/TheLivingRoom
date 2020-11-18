import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class household extends StatefulWidget {
  @override
  _householdstate createState() => _householdstate();
}

class Upload extends StatefulWidget {
  @override
  _Uploadstate createState() => _Uploadstate();

}

class roomies extends StatefulWidget {
  @override
  _roomiesstate createState() => _roomiesstate();

}

class _householdstate extends State<household> {
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
                    MaterialPageRoute(builder: (context) => roomies()),
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
  String _uploadedFileURL;
  final picker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {
    
    Future chooseImage() async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });

      _uploadedFileURL = path.basename(_image.path);

      Reference ref = FirebaseStorage.instance.ref('Documents').child(_uploadedFileURL);
      UploadTask uploadTask = ref.putFile(_image);
    }//chooseImage
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload a photo"),
      ),
      body: Builder(
        builder: (context)=> Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      child: SizedBox(
                        width:150.0,
                        height:300.0,
                        child:(_image != null)?Image.file(_image)
                        :Image.network(
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
                        child:(_imageList != null)?Image.file(_imageList)
                            :Image.network(
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



  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => null);
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}

class _roomiesstate extends State<roomies> {
  final fb = FirebaseDatabase.instance;
  final databaseReference = FirebaseFirestore.instance;
  final User currentUser = FirebaseAuth.instance.currentUser;
  final myController = TextEditingController();
  final name = "Name";
  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
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
                    //final householdID = databaseReference.collection("users").doc(currentUser.uid);
                    //final userRef = databaseReference.collection("household").doc(householdID).get();
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

Future<String> addHouseholdMember(String username ) async {
final databaseReference = FirebaseFirestore.instance;
final User currentUser = FirebaseAuth.instance.currentUser;
String houseID;
DocumentSnapshot userDoc = await databaseReference.collection('users').doc(currentUser.uid).get();
houseID = userDoc.data()['household']; //get household ID from user document
if(houseID == null){
  //val data = hashMapOf("member")
  //databaseReference.collection('household').doc(currentUser.uid).set()
}
var member = {username:null};
//final householdID = await databaseReference.collection("household").doc(houseID).set(member, SetOptions.merge());
}
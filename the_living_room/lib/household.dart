import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

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

      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Upload()),
          );
        },
        tooltip: 'Upload a photo',
        child: const Icon(Icons.add_a_photo),
      ),*/
    );
  }
}

class _Uploadstate extends State<Upload>{
  @override
  File _image;
  String _uploadedFileURL;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload a photo"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null
                ? Image.asset(
              _image.path,
              height: 150,
            )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
              child: Text('Choose File'),
              onPressed: chooseFile,
              color: Colors.cyan,
            )
                : Container(),
            _image != null
                ? RaisedButton(
              child: Text('Upload File'),
              onPressed: uploadFile,
              color: Colors.cyan,
            )
                : Container(),
            /*_image != null
                ? RaisedButton(
              child: Text('Clear Selection'),
              onPressed: clear(),
            )
                : Container(),*/
            Text('Uploaded Image'),
            _uploadedFileURL != null
                ? Image.network(
              _uploadedFileURL,
              height: 150,
            )
                : Container(),
            RaisedButton(
              child: Text('Back'),
              onPressed: (){
                Navigator.pop(context);
              },
              color: Colors.cyan,
            ),

          ],
        ),


        /*child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Back'),
          ),
        ),*/
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add roommates"),
        ),
        body: Center(
          child: Column(
              children: <Widget>[
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

import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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
}
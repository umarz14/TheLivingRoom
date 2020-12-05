import 'LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: LoginPage(),
      image:  Image.asset('assets/images/theLivingRoom.jpg'),
      photoSize: MediaQuery.of(context).size.width* .5,
      //title: new Text('TheLivingRoom',style: TextStyle(fontFamily: 'PoetsenOne', fontSize: 60, color: Colors.white,), ),
      backgroundColor: Colors.blueGrey,
      loadingText: Text("Loading"),
      loaderColor: Colors.grey,
    );
  }
}
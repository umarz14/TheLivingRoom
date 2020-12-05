import 'package:flutter/material.dart';
import 'package:the_living_room/TodoApp/TodoApp.dart';
import 'package:the_living_room/table_calendar.dart';
import 'notes.dart';
import 'LoginPage.dart';
import 'household.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_living_room/splash.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //creates firebase instance
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home Page',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home:UserLogin(),
        home: Splash()
      //home: MyHomePage(title: 'TheLivingRoom'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeCalendar(),
    ToDoApp(),
    Notes(),
    Household(),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: _children[_currentIndex],

      //nav bar to flip between pages
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,//will be set when new tab tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            label: 'Task',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.note),
            label: 'Notes',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
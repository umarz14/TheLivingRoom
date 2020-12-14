import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


class HomeCalendar extends StatefulWidget {
  @override
  _HomeCalState createState() => _HomeCalState();
}


class _HomeCalState extends State<HomeCalendar> {

  String houseID; //needs to be declared outside of gethouseHold or it won't work
  bool loadingHouse = true;
  bool loadingData = true;
  MeetingDataSource eventData;
  List<Meeting> appointments = <Meeting>[];

  //get household ID from user
  String getHouseHold() {
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    //print('user id {$id}');
    databaseReference.collection("users").doc(currentUser.uid).get().then((
        value) {
      houseID = value.data()['household'];
      setState(() {
        loadingHouse = false;
      });
      //return houseID;
    });
    //print('house id in getHouseHold {$houseID}');
    return houseID;
  }

  //function that allows user to add event
  void addEventItem(String eventName, DateTime start, DateTime end) async {
    final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("User is NULL");
    }
    String householdID = getHouseHold(); //works here
    //print('house id in addNoteItem {$householdID}');
    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("household").doc(householdID)
        .collection("events")
        .add(
        {
          "eventName": eventName,
          "from": start,
          "to": end,
          "isAllDay": true,
        }
    );
  } // addEventItem

  void pushAddEvent() {
    //declare variables to store for upload
    DateTime _start;
    DateTime _end;
    String _eventName;

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: AppBar(
                    title: Text("new Event"),
                  ),
                  body: new Container(
                    child: new Column(
                      children: <Widget>[
                        RaisedButton( //Start Date
                          child: Text('Select Start Date'),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: _start == null
                                    ? DateTime.now()
                                    : _start,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2077)
                            ).then((date) {
                              setState(() {
                                _start = date;
                              });
                            });
                          },
                        ),

                        RaisedButton( //END  Date
                          child: Text('Select End Date'),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: _end == null
                                    ? DateTime.now()
                                    : _end,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2077)
                            ).then((date) {
                              setState(() {
                                _end = date;
                              });
                            });
                          },
                        ),

                        TextField(
                          decoration:
                          InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: _eventName == null
                                ? 'Enter event name'
                                : _eventName,
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              _eventName = value;
                            });
                          },
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // _eventName = "banana";
                              //validate and create event if form valid
                              if (_start != null && _end != null &&
                                  _eventName != null) {
                                addEventItem(_eventName, _start, _end);
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        )

                      ],
                    ),
                  )
              );
            } //builder
        )
    ); //nav
  } //pushAddEvent


  @override
  Widget build(BuildContext context) {
    //String householdID;
    MeetingDataSource calendarData;
    calendarData = MeetingDataSource(appointments);
    //causes error, but function sets global, so leave for now
    //householdID = getHouseHold();
    getHouseHold();
    //if(loadingHouse) return CircularProgressIndicator();
    if (loadingHouse || loadingData) {
      loadingData = false;
      getCalendarDataSource();
      return CircularProgressIndicator();
    }
      return Scaffold(
        body: Container(
          child: SfCalendar(
            view: CalendarView.month,
            showNavigationArrow: true,
            todayHighlightColor: Colors.grey,
            dataSource: calendarData,
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: pushAddEvent,
          tooltip: 'Add Note',
          child: Icon(Icons.add),
        ),
      );
    }// Widget


//a list for general meetings that can be adjusted
void getCalendarDataSource() {
  //HARD CODED EVENTS
    //List<Meeting> appointments = <Meeting>[];
    appointments.add(Meeting(
      from: DateTime.now(),
      to: DateTime.now().add(const Duration(hours: 1)),
      eventName: 'Meeting',
      isAllDay: true,
    ));
    appointments.add(Meeting(
      from: DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 0),
      to: DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month + 1, 0, 1),
      eventName: 'Rent Due',
      isAllDay: true,
    ));
    //END HARD CODED EVENTS

    FirebaseFirestore.instance.collection("household").doc(
        "RRpXs6hUf2e7nXlNp5I0Az0ci9r1").collection("events").get().then((
        querySnapshot) {
      //print("searching");
      querySnapshot.docs.forEach((result) {
        appointments.add(Meeting(
          from: result.data()['from'].toDate(),
          to: result.data()['to'].toDate(),
          eventName: result.data()['eventName'],
          isAllDay: true,
        ));
      });

    });
  }
}


//Constructor from calendar, will assign to calendarDataSource
class MeetingDataSource extends CalendarDataSource{
    MeetingDataSource(List<Meeting> source){
      appointments = source;
    }
    @override
    DateTime getStartTime(int index) {
      return appointments[index].from;
    }
    @override
    DateTime getEndTime(int index) {
      return appointments[index].to;
    }
    @override
    String getSubject(int index) {
      return appointments[index].eventName;
    }
    @override
    Color getColor(int index) {
      return Colors.red;
    }
    @override
    bool isAllDay(int index) {
      return appointments[index].isAllDay;
    }
}

//Class definition of Meeting
class Meeting {
  Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay=false});
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}


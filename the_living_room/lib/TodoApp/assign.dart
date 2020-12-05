/*import 'package:flutter/material.dart';
import 'package:the_living_room/database/database.dart';
import 'package:provider/provider.dart';

class User {
  final String email;
  final String household;
  final String name;

  User({ this.email, this.household, this.name});
}

class UserTile extends StatelessWidget {

  final User user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListTile(
          leading: CircleAvatar( // put user profile pics here later
            radius: 25,
            backgroundColor: Colors.grey,
          ),
          title: Text(user.name),
        ),
      ),
    );
  }
}


class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context);
    /*users.forEach((user) {
      print(user.name);
      print(user.household);
      print(user.email);
    });*/
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index){
          return UserTile(user: users[index]);
        },
    );
  } // End of build
} // End of _UserListState


class AssignToRoomate extends StatefulWidget {
  @override
  _AssignToRoomateState createState() => _AssignToRoomateState();
}

class _AssignToRoomateState extends State<AssignToRoomate> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
      value: DatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Assign To..."),
          centerTitle: true,
        ),
        body: UserList(),
      ),
    );
  }
}
*/
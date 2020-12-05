import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_living_room/TodoApp/assign.dart';

class DatabaseService {


  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('household').doc('RRpXs6hUf2e7nXlNp5I0Az0ci9r1').collection('task');

  Future addTask(String task, String creator, String assigned) async {
    return await taskCollection.doc(uid).set({
      'task': task,
      'creator': creator,
      'assigned': assigned
    });
  }


  // User list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return User(
        email: doc.data()['email'] ?? 'no email', // If doesn't exist return empty string
        household: doc.data()['household'] ?? 'no household',
        name: doc.data()['name'] ?? 'no name'
      );
    }).toList();
  }


  // Get task stream
  Stream<QuerySnapshot> get tasks{
    return taskCollection.snapshots();
  }

  Stream<List<User>> get users{
    return userCollection.snapshots()
    .map(_userListFromSnapshot);
  }

}
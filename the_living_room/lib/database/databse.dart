import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');

  Future updateUserData(String task, String creator, String assigned) async {
    return await taskCollection.doc(uid).set({
      'task': task,
      'creator': creator,
      'assigned': assigned
    });
  }

  // Get task stream
  Stream<QuerySnapshot> get tasks{
    return taskCollection.snapshots();
  }

  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }

}
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_living_room/TodoApp/assign.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('household').doc().collection('tasks');

  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }

}
 */
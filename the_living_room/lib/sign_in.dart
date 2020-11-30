import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_living_room/database/databse.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final auth.UserCredential authResult = await _auth.signInWithCredential(credential);
  final auth.User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  //final auth.User currentUser = await _auth.currentUser();
  final auth.User currentUser = auth.FirebaseAuth.instance.currentUser;
  assert(user.uid == currentUser.uid);
  final databaseReference = FirebaseFirestore.instance;
  await databaseReference.collection("users")
      .doc(user.uid)
      .set({
    'name': user.displayName,
    'email': user.email,
  });


  print(user.uid);
  //create new collection for every member with their uid
  await DatabaseService(uid:user.uid).updateTaskData('Add new task', user.displayName, user.displayName);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}
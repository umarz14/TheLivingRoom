package com.example.the_living_room

import io.flutter.embedding.android.FlutterActivity

private fun initFirestore() {
    firestoreInstance = FirebaseFirestore.getInstance()
}
class MainActivity: FlutterActivity() {
    initFirestore();
}

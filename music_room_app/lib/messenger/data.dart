import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_room_app/home/models/user.dart';

// User user = FirebaseAuth.instance.currentUser!;
final user = FirebaseFirestore.instance.collection('user_info').get();

String myId = user as String;
// String myUsername = myId.;

// String myId = 'INxPTqI0xAhsj8REKLmsQc6W08A3';
// String myUsername = 'Samuel Coron';

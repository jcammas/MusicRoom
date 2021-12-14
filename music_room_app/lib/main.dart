import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/views/landing.dart';
import 'package:music_room_app/views/login/login.dart';
import 'package:music_room_app/views/sign_in/sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Room',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingScreen(
        auth: Auth()
      ),
    );
  }
}

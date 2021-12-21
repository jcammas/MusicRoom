import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/home/home.dart';
import 'package:provider/provider.dart';
import 'landing.dart';
import 'services/auth.dart';

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
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Music Room',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const LandingScreen(),
        initialRoute: "/",
        routes: {
          '/': (_) => const LandingScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          Account.routeName: (_) => const Account()
        },
      ),
    );
  }
}

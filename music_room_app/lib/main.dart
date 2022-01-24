import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/messenger/chats_page.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/spotify_library/library/library.dart';
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
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth()),
        Provider<Database>(create: (context) => FirestoreDatabase()),
        Provider<Spotify>(create: (context) => SpotifyService())
      ],
      child: MaterialApp(
        title: 'Music Room',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          '/': (_) => const LandingScreen(),
          AccountScreen.routeName: (_) => const AccountScreen(),
          LibraryScreen.routeName: (_) => const LibraryScreen(),
          ChatsPage.routeName: (_) => const ChatsPage(),
        },
      ),
    );
  }
}

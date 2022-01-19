import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/messenger/chats_page.dart';
import 'package:music_room_app/messenger/chat.dart';
import 'package:music_room_app/friends/friends.dart';
import 'package:music_room_app/messenger/messenger.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/spotify_library/library/library.dart';
import 'package:provider/provider.dart';
import 'landing.dart';
import 'services/auth.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

const _primaryColor = Color(0XFF072BB8);
const _lightBlue = const Color(0xFFE1F5FE);
const _backgroundWhite = const Color(0xFFEFEFF4);
const _lightGrey = const Color(0xFF757575);
const _lightDark = const Color(0x8A000000);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return _primaryColor;
    }
    return _lightDark;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth()),
        Provider<Database>(create: (context) => FirestoreDatabase()),
        Provider<Spotify>(create: (context) => SpotifyService()),
        Provider<StorageService>(create: (context) => StorageService())
      ],
      child: MaterialApp(
        title: 'Music Room',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,

          //Our 'signature' color for appBar, main buttons, etc.
          primaryColor: _primaryColor,
          secondaryHeaderColor: _lightBlue,

          //Background color across the app
          backgroundColor: _backgroundWhite,

          //Shadow colors
          shadowColor: _lightGrey,

          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(getColor),
                padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
                alignment: Alignment.centerLeft),
          ),

          // Define the default font family (Left some examples to try which one suits us best).
          // fontFamily: GoogleFonts.openSans().fontFamily,
          // fontFamily: GoogleFonts.playfairDisplay().fontFamily,
          // fontFamily: GoogleFonts.roboto().fontFamily,
          fontFamily: GoogleFonts.montserrat().fontFamily,

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w800,
                color: Colors.white),
            headline5: TextStyle(
                fontSize: 18.0, color: _lightDark, fontWeight: FontWeight.w600),
            headline6: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: "/",
        routes: {
          '/': (_) => const LandingScreen(),
          AccountScreen.routeName: (_) => const AccountScreen(),
          LibraryScreen.routeName: (_) => const LibraryScreen(),
          ChatsPage.routeName: (_) => const ChatsPage(),
          MessengerScreen.routeName: (_) => MessengerScreen(),
          ChatScreen.routeName: (_) => const ChatScreen(),
          FriendsScreen.routeName: (_) => const FriendsScreen(),
        },
      ),
    );
  }
}

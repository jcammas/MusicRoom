import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/messenger/chats_page.dart';
import 'package:music_room_app/friends/friends.dart';
import 'package:music_room_app/room/room_screen.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify_web.dart';
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

const _primaryColor = const Color(0XFF072BB8);
const _lightBlue = const Color(0xFFE1F5FE);
const _backgroundWhite = const Color(0xFFEFEFF4);
const _lightGrey = const Color(0xFF757575);
const _lightDark = const Color(0x8A000000);

Map<String, Widget Function(BuildContext)> routeMap = {
  '/': (_) => const LandingScreen(),
  AccountScreen.routeName: (_) => const AccountScreen(),
  LibraryScreen.routeName: (_) => const LibraryScreen(),
  ChatsPage.routeName: (_) => const ChatsPage(),
  FriendsScreen.routeName: (_) => const FriendsScreen(),
  RoomScreen.routeName: (_) => RoomScreen.create(),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Color getColorForegroundColor(Set<MaterialState> states) {
  //   const Set<MaterialState> interactiveStates = <MaterialState>{
  //     MaterialState.pressed,
  //     MaterialState.hovered,
  //     MaterialState.focused,
  //   };
  //   if (states.any(interactiveStates.contains)) {
  //     return _primaryColor;
  //   }
  //   return _lightDark;
  // }

  // TextStyle getTextStyle(Set<MaterialState> states) {
  //   const Set<MaterialState> interactiveStates = <MaterialState>{
  //     MaterialState.pressed,
  //     MaterialState.hovered,
  //     MaterialState.focused,
  //   };
  //   if (states.any(interactiveStates.contains)) {
  //     return TextStyle(
  //       fontSize: 16.0,
  //       fontWeight: FontWeight.w500,
  //     );
  //   }
  //   return TextStyle(
  //     fontSize: 16.0,
  //     fontWeight: FontWeight.w500,
  //   );
  // }

  //   textButtonTheme: TextButtonThemeData(
  //   style: ButtonStyle(
  //       foregroundColor: MaterialStateProperty.resolveWith(getColor),
  //       padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
  //       alignment: Alignment.centerLeft),
  // ),

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth()),
        Provider<Database>(create: (context) => FirestoreDatabase()),
        Provider<SpotifyWeb>(create: (context) => SpotifyWebService()),
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

          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: _primaryColor,
                  padding: EdgeInsets.all(10))),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                primary: _lightDark,
                padding: EdgeInsets.all(2.0),
                alignment: Alignment.centerLeft,
                maximumSize: Size(600, 100)),
          ),

          // Define the default font family (Left some examples to try which one suits us best).
          // fontFamily: GoogleFonts.openSans().fontFamily,
          // fontFamily: GoogleFonts.playfairDisplay().fontFamily,
          fontFamily: GoogleFonts.roboto().fontFamily,
          // fontFamily: GoogleFonts.montserrat().fontFamily,

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
              headline1: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
              headline5: TextStyle(
                  fontSize: 18.0,
                  color: _lightDark,
                  fontWeight: FontWeight.w600),
              headline6: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              overline: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ),
        initialRoute: "/",
        routes: routeMap,
      ),
    );
  }
}

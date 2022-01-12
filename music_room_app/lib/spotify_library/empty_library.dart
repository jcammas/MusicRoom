import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyLibrary extends StatelessWidget {
  const EmptyLibrary(
      {Key? key,
      required this.refreshFunction})
      : super(key: key);
  final String title = 'Hit me';
  final Future<void> Function(BuildContext context) refreshFunction;

  @override
  Widget build(BuildContext context) {
    const double size = 10;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                    fontSize: 4 * size,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: CircleAvatar(
                    radius: 6 * size,
                    backgroundColor: Colors.black,
                    child: Image.asset("images/spotify_icon.png"),
                  ),
                  iconSize: 12 * size,
                  onPressed: () => refreshFunction(context),
                )),
          )
        ],
      ),
    );
  }
}

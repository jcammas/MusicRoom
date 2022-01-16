import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeOverflow extends StatelessWidget {
  const MarqueeOverflow(
      {Key? key,
        required this.text,
        required this.width,
        this.height = 30,
        this.maxLength = 20,
        this.textStyle
      })
      : super(key: key);

  final String text;
  final int maxLength;
  final double width;
  final double height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.topLeft,
      child: text.length < 21
          ? Text(
        text,
        style: textStyle,
      )
          : Marquee(
        text: text,
        style: textStyle,
        blankSpace: 70.0,
      ),
    );
  }
}
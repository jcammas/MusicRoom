import 'package:flutter/material.dart';

class TitledSwitch extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? themeColor;
  final MainAxisAlignment alignment;

  TitledSwitch({
    required this.onChanged,
    required this.title,
    required this.value,
    this.icon = Icons.lock,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.w500,
    this.alignment = MainAxisAlignment.center,
    this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    Color color = themeColor ?? Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: Color(0XFF434343),
            fontWeight: fontWeight,
          ),
        ),
        Switch(
          activeTrackColor: color,
          activeColor: color,
          value: value,
          onChanged: onChanged,
        ),
        value ? Icon(icon, color: color) : SizedBox(),
      ],
    );
  }
}

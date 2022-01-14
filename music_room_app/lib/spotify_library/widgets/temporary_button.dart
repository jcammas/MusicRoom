import 'package:flutter/material.dart';

class TemporaryButton extends StatelessWidget {
  const TemporaryButton(
      {Key? key,
      required this.width,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  final double width;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Music Room'),
      elevation: 2.0,
      backgroundColor: const Color(0XFF072BB8),
    );
  }
}

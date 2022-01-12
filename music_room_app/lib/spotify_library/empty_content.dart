import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
    this.title = 'Nothing here',
    this.message = 'Please refresh !',
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 30.0, color: Colors.black54),
          ),
          Text(
            message,
            style: const TextStyle(fontSize: 18.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

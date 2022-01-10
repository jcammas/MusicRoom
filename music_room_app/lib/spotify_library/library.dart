import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'library_form.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  static const String routeName = '/library';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'Library', context: context),
      backgroundColor: const Color(0xFFEFEFF4),
      drawer: const MyDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: LibraryForm.create(context)),
    );
  }
}

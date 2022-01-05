import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'account_form2.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  static const String routeName = '/home/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'My Account', context: context),
      backgroundColor: Colors.grey[200],
      drawer: const MyDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: AccountForm2.create(context),
      ),
    );
  }
}

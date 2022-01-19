import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'account_form.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  static const String routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'My Account', context: context),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: const MyDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: AccountForm.create(context),
      ),
    );
  }
}

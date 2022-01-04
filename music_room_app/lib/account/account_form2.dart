import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/settings_dialog.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';

class AccountForm2 extends StatefulWidget {
  const AccountForm2({Key? key}) : super(key: key);

  @override
  State<AccountForm2> createState() => _AccountForm2State();
}

class _AccountForm2State extends State<AccountForm2> {
  late Map<String, dynamic> settingsData;

  Map<String, dynamic> fillSettingsData(UserApp? user) {
    return <String, dynamic>{
      'Name': user == null ? 'Loading...' : user.name,
      'Email': user == null ? 'Loading...' : user.email,
    };
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<UserApp>(
      stream: db.userStream(),
      builder: (context, snapshot) {
        UserApp? user = snapshot.data;
        settingsData = fillSettingsData(user);
        return SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: 'Name',
                  subtitle: settingsData['Name'].toString(),
                  leading: const Icon(Icons.face),
                  onPressed: (BuildContext context) async {
                    if (user != null) {
                      await showSettingsDialog(
                              context,
                              'Name',
                              settingsData['Name'].toString(),
                              const Icon(Icons.face))
                          .then((String newValue) {
                        user.name = newValue;
                      });
                      if (auth.currentUser != null) {
                        await auth.currentUser?.updateDisplayName(user.name);
                      }
                      await db.updateUser(user);
                    }
                  },
                ),
                SettingsTile(
                  title: 'Email',
                  subtitle: settingsData['Email'].toString(),
                  leading: const Icon(Icons.email),
                  onPressed: (BuildContext context) async {
                    if (user != null) {
                      await showSettingsDialog(
                              context,
                              'Email',
                              settingsData['Email'].toString(),
                              const Icon(Icons.email))
                          .then((String newValue) {
                        user.email = newValue;
                      });
                      if (auth.currentUser != null) {
                        await auth.currentUser?.updateEmail(user.email); //got to do a proper updateEmail function in auth with exceptions
                      }
                      await db.updateUser(user);
                      await showAlertDialog(context, title: 'New Email Sent', content: 'Please check your inbox to verify your new email address.', defaultActionText: 'Ok');
                    }
                  },
                ),
                SettingsTile(
                  title: 'Devices Settings',
                  leading: const Icon(Icons.radio),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Privacy Settings',
                  leading: const Icon(Icons.privacy_tip),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Default Room Settings',
                  leading: const Icon(Icons.music_note),
                  onPressed: (BuildContext context) {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

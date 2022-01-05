import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:music_room_app/account/widgets/custom_settings_tile.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';
import 'account_model.dart';

class AccountForm2 extends StatefulWidget {
  const AccountForm2({Key? key, required this.model}) : super(key: key);
  final AccountModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<AccountModel>(
      create: (_) => AccountModel(auth: auth, db: db),
      child: Consumer<AccountModel>(
        builder: (_, model, __) => AccountForm2(model: model),
      ),
    );
  }

  @override
  State<AccountForm2> createState() => _AccountForm2State();
}

class _AccountForm2State extends State<AccountForm2> {
  late Map<String, dynamic> settingsData;

  Map<String, dynamic> fillSettingsData(UserApp? user) {
    return <String, dynamic>{
      'Name': user == null ? 'N/A' : user.name,
      'Email': user == null ? 'N/A' : user.email,
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserApp>(
      stream: widget.model.getUserStream(),
      builder: (context, snapshot) {
        UserApp? user = snapshot.data;
        settingsData = fillSettingsData(user);
        return SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                CustomSettingsTile(
                    type: SettingType.name,
                    title: 'Name',
                    model: widget.model,
                    user: user,
                    subtitle: settingsData['Name'].toString(),
                    iconData: Icons.face),
                CustomSettingsTile(
                    type: SettingType.email,
                    title: 'Email',
                    model: widget.model,
                    user: user,
                    subtitle: settingsData['Email'].toString(),
                    iconData: Icons.email),
                CustomSettingsTile(
                    type: SettingType.password,
                    title: 'Change Password',
                    model: widget.model,
                    user: user,
                    iconData: Icons.lock),
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
                CustomSettingsTile(
                    type: SettingType.delete,
                    title: 'Delete Account',
                    model: widget.model,
                    user: user,
                    iconData: Icons.delete_forever),
              ],
            ),
          ],
        );
      },
    );
  }
}

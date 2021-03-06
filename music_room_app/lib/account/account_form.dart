import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:music_room_app/account/widgets/custom_settings_tile.dart';
import 'package:music_room_app/account/widgets/privacy_settings.dart';
import 'package:music_room_app/account/widgets/avatar_tile.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';
import '../constant_colors.dart';
import '../services/storage_service.dart';
import 'account_manager.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({Key? key, required this.manager}) : super(key: key);
  final AccountManager manager;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    final storage = Provider.of<StorageService>(context, listen: false);
    return ChangeNotifierProvider<AccountManager>(
      create: (_) => AccountManager(auth: auth, db: db, storage: storage),
      child: Consumer<AccountManager>(
        builder: (_, manager, __) => AccountForm(manager: manager),
      ),
    );
  }

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  late Map<String, dynamic> settingsData;

  Map<String, dynamic> fillSettingsData(UserApp? user) {
    return <String, String>{
      'Name': user == null ? 'N/A' : user.name,
      'Email': user == null ? 'N/A' : user.email,
    };
  }

  Future<void> showPrivacySettings(context) async {
    await showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          maxHeight: MediaQuery
              .of(context)
              .size
              .height * 0.8,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return PrivacySettingsForm();
        });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<UserApp>(
      stream: widget.manager.getUserStream(),
      builder: (context, snapshot) {
        UserApp? user = snapshot.data;
        settingsData = fillSettingsData(user);
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AvatarTile(
                      user: user,
                      imagePickFn: widget.manager.updateAvatar),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: screenHeight * 0.7,
                child: SettingsList(
                  sections: [
                    SettingsSection(
                      tiles: [
                        CustomSettingsTile(
                            type: SettingType.name,
                            title: 'Name',
                            manager: widget.manager,
                            user: user,
                            subtitle: settingsData['Name'],
                            iconData: Icons.face),
                        CustomSettingsTile(
                            type: SettingType.email,
                            title: 'Email',
                            manager: widget.manager,
                            user: user,
                            subtitle: settingsData['Email'],
                            iconData: Icons.email),
                        CustomSettingsTile(
                            type: SettingType.newPassword,
                            title: 'Change Password',
                            manager: widget.manager,
                            user: user,
                            iconData: Icons.lock),
                        SettingsTile(
                          title: 'Privacy Settings',
                          leading: const Icon(
                            Icons.privacy_tip,
                            color: primaryColor,
                          ),
                          onPressed: (BuildContext context) {
                            showPrivacySettings(context);
                          },
                        ),
                        SettingsTile(
                          title: 'Default Room Settings',
                          leading: const Icon(Icons.music_note),
                          onPressed: (BuildContext context) {},
                        ),
                        CustomSettingsTile(
                            type: SettingType.delete,
                            title: 'Delete Account',
                            manager: widget.manager,
                            user: user,
                            iconData: Icons.delete_forever),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

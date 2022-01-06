import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:music_room_app/account/widgets/settings_dialog.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/widgets/sign_in_type.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import '../account_model.dart';

enum SettingType { name, email, password, delete }

class CustomSettingsTile extends AbstractTile {
  const CustomSettingsTile(
      {Key? key,
      required this.type,
      required this.title,
      required this.model,
      required this.user,
      this.subtitle,
      this.iconData})
      : super(key: key);
  final String title;
  final AccountModel model;
  final IconData? iconData;
  final String? subtitle;
  final UserApp? user;
  final SettingType type;

  Future<void> makeAChange(
      BuildContext context,
      String settingName,
      String? currentValue,
      Widget? leading,
      AccountModel model,
      SettingType type) async {
    if (type != SettingType.delete ||
        model.findSignInType() == SignInType.email) {
      await showSettingsDialog(context, title, subtitle, leading, model, type);
    }
    try {
      switch (type) {
        case SettingType.name:
          await model.updateName(user);
          break;
        case SettingType.email:
          await model.updateEmail(user);
          await showAlertDialog(context,
              title: 'New Email Sent',
              content: const Text(
                  'Please check your inbox to verify your new email address.'),
              defaultActionText: 'Ok');
          break;
        case SettingType.password:
          await model.updatePassword();
          break;
        case SettingType.delete:
          await model.deleteUser(user);
          Navigator.of(context).pop();
          break;
        default:
          break;
      }
    } on Exception catch (e) {
      await showExceptionAlertDialog(context, title: 'ERROR', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget? leading = Icon(iconData, color: const Color(0XFF072BB8));
    return SettingsTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        onPressed: (BuildContext context) async {
          if (type == SettingType.delete) {
            await showAlertDialog(context,
                    title: 'Deleting account',
                    content: const Text('Are you sure ?'),
                    defaultActionText: 'Sure',
                    cancelActionText: 'Cancel')
                .then((dynamic confirmed) async {
              if (confirmed == true) {
                await makeAChange(
                    context, title, subtitle, leading, model, type);
              }
            });
          } else {
            await makeAChange(context, title, subtitle, leading, model, type);
          }
        });
  }
}

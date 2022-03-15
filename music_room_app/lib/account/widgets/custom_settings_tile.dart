import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:music_room_app/account/widgets/settings_dialog.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/widgets/sign_in_type.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import '../account_manager.dart';

enum SettingType { name, email, oldPassword, newPassword, delete }

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
  final AccountManager model;
  final IconData? iconData;
  final String? subtitle;
  final UserApp? user;
  final SettingType type;

  Future<void> makeAChange(
      BuildContext context,
      String settingName,
      String? currentValue,
      Widget? leading,
      AccountManager model,
      SettingType type) async {
    SignInType signInType = model.findSignInType();
    try {
      switch (type) {
        case SettingType.name:
          await showSettingsDialog(
              context, title, subtitle, leading, model, type);
          await model.updateName(user);
          break;

        case SettingType.email:
          if (signInType == SignInType.email) {
            await showSettingsDialog(context, title, '', leading, model,
                SettingType.oldPassword);
            await model.reAuthenticateUser();
            await showSettingsDialog(
                context, title, subtitle, leading, model, type);
            await model.updateEmail(user);
            await showAlertDialog(context,
                title: 'New Email Sent',
                content: const Text(
                    'Please check your inbox to verify your new email address.'),
                defaultActionText: 'Ok');
          } else {
            throw Exception(
                'You can\'t update your email with a Google or Facebook signIn.');
          }
          break;

        case SettingType.newPassword:
          if (signInType == SignInType.email) {
            await showSettingsDialog(context, title, '', leading, model,
                SettingType.oldPassword);
            await model.reAuthenticateUser();
            await showSettingsDialog(
                context, title, subtitle, leading, model, type);
            await model.updatePassword();
          } else {
            throw Exception(
                'You can\'t update your password with a Google or Facebook signIn.');
          }
          break;

        case SettingType.delete:
          if (signInType == SignInType.email) {
            await showSettingsDialog(
                context, title, '', leading, model, SettingType.oldPassword);
          }
          await model.reAuthenticateUser();
          await model.deleteUser();
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

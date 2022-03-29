import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:music_room_app/account/widgets/settings_dialog.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/widgets/sign_in_type.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import '../../constant_colors.dart';
import '../account_manager.dart';

enum SettingType { name, email, oldPassword, newPassword, delete }

class CustomSettingsTile extends AbstractTile {
  const CustomSettingsTile(
      {Key? key,
      required this.type,
      required this.title,
      required this.manager,
      required this.user,
      this.subtitle,
      this.iconData})
      : super(key: key);
  final String title;
  final AccountManager manager;
  final IconData? iconData;
  final String? subtitle;
  final UserApp? user;
  final SettingType type;

  Future<void> makeAChange(
      BuildContext context,
      String settingName,
      String? currentValue,
      Widget? leading,
      AccountManager manager,
      SettingType type) async {
    SignInType signInType = manager.findSignInType();
    try {
      switch (type) {
        case SettingType.name:
          await showSettingsDialog(
              context, title, subtitle, leading, manager, type);
          await manager.updateName(user);
          manager.notSubmitted();
          break;

        case SettingType.email:
          if (signInType == SignInType.email) {
            await showSettingsDialog(
                context,
                title,
                '',
                const Icon(Icons.lock, color: primaryColor),
                manager,
                SettingType.oldPassword);
            if (manager.submitted) {
              manager.notSubmitted();
              await manager.reAuthenticateUser();
              await showSettingsDialog(
                  context, title, subtitle, leading, manager, type);
              await manager.updateEmail(user);
              if (manager.submitted) {
                manager.notSubmitted();
                await showAlertDialog(context,
                    title: 'New Email Sent',
                    content: const Text(
                        'Please check your inbox to verify your new email address.'),
                    defaultActionText: 'Ok');
              }
            }
          } else {
            throw Exception(
                'You can\'t update your email with a Google or Facebook signIn.');
          }
          break;

        case SettingType.newPassword:
          if (signInType == SignInType.email) {
            await showSettingsDialog(
                context,
                title,
                '',
                const Icon(Icons.lock, color: primaryColor),
                manager,
                SettingType.oldPassword);
            if (manager.submitted) {
              manager.notSubmitted();
              await manager.reAuthenticateUser();
              await showSettingsDialog(
                  context, title, subtitle, leading, manager, type);
              await manager.updatePassword();
              manager.notSubmitted();
            }
          } else {
            throw Exception(
                'You can\'t update your password with a Google or Facebook signIn.');
          }
          break;

        case SettingType.delete:
          if (signInType == SignInType.email) {
            await showSettingsDialog(
                context,
                title,
                '',
                const Icon(Icons.lock, color: primaryColor),
                manager,
                SettingType.oldPassword);
          }
          if (manager.submitted) {
            manager.notSubmitted();
            await manager.reAuthenticateUser();
            await manager.deleteUser();
            Navigator.of(context).pop();
          }
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
    final Widget? leading = Icon(iconData, color: primaryColor);
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
                    context, title, subtitle, leading, manager, type);
              }
            });
          } else {
            await makeAChange(context, title, subtitle, leading, manager, type);
          }
        });
  }
}

import 'package:flutter/material.dart';
import '../account_manager.dart';
import 'custom_settings_tile.dart';

TextInputType _getTextInputType(SettingType type) {
  switch (type) {
    case SettingType.name:
      return TextInputType.name;
    case SettingType.email:
      return TextInputType.emailAddress;
    case SettingType.oldPassword:
    case SettingType.newPassword:
      return TextInputType.visiblePassword;
    default:
      return TextInputType.text;
  }
}

void _submit(BuildContext context, AccountManager model, SettingType type) {
  model.isSubmitted();
  if (model.canSubmit(type) == true) {
    Navigator.of(context).pop();
  }
}

Future<String?> showSettingsDialog(
    BuildContext context,
    String settingName,
    String? currentValue,
    Widget? leading,
    AccountManager model,
    SettingType type) async {
  model.updateSettingValue(currentValue ?? '');
  final String titleText = type == SettingType.oldPassword
      ? 'Type your current password :'
      : 'Make a Change !';
  final bool obscureText =
      (type == SettingType.oldPassword || type == SettingType.newPassword)
          ? true
          : false;
  return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    titleText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  keyboardType: _getTextInputType(type),
                  obscureText: obscureText,
                  textInputAction: TextInputAction.done,
                  initialValue: currentValue,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 46, top: 16),
                    errorText: model.showError ? 'Can\'t be empty' : null,
                    prefixIcon: leading,
                  ),
                  onChanged: (String value) {
                    model.updateSettingValue(value);
                  },
                  onEditingComplete: () => _submit(context, model, type),
                ),
              ),
              TextButton(
                onPressed: () => _submit(context, model, type),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(12)),
                  alignment: Alignment.center,
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        });
      });
}

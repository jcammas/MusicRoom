import 'package:flutter/material.dart';
import '../account_model.dart';
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

void _submit(BuildContext context, AccountModel model, SettingType type) {
  if (model.canSubmit(type) == true) {
    Navigator.of(context).pop();
  }
}

Future<String?> showSettingsDialog(
    BuildContext context,
    String settingName,
    String? currentValue,
    Widget? leading,
    AccountModel model,
    SettingType type) async {
  model.updateSettingValue(currentValue ?? '');
  final String titleText = type == SettingType.oldPassword
      ? 'Type your password :'
      : 'Make a Change !';
  final bool obscureText =
      (type == SettingType.oldPassword || type == SettingType.newPassword)
          ? true
          : false;
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
            title: Center(child: Text(titleText)),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: _getTextInputType(type),
                  textAlign: TextAlign.left,
                  obscureText: obscureText,
                  textInputAction: TextInputAction.done,
                  initialValue: currentValue,
                  decoration: InputDecoration(
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
                        const EdgeInsets.all(16))),
                child: const Text('Apply'),
              ),
            ],
          );
        });
      });
}

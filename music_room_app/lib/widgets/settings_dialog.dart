import 'package:flutter/material.dart';

Future<String> showSettingsDialog(
  BuildContext context,
  String settingName,
    String currentValue,
    Icon icon,
) async {
  String returnValue = currentValue;
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
            title: const Center(child: Text('Settings')),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                    initialValue: currentValue,
                    decoration: InputDecoration(
                        icon: icon, labelText: settingName),
                    onChanged: (String value) =>
                        setState(() => returnValue = value)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(returnValue);
                },
                style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16))),
                child: const Text('Apply'),
              ),
            ],
          );
        });
      });
}

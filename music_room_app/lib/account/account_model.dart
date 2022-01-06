import 'package:flutter/material.dart';
import 'package:music_room_app/account/widgets/custom_settings_tile.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/sign_in_type.dart';
import 'package:music_room_app/widgets/validators.dart';
import 'package:music_room_app/services/auth.dart';

class AccountModel with ChangeNotifier {
  AccountModel(
      {required this.auth,
      required this.db,
      this.settingValue = '',
      this.submitted = false,
      this.isLoading = false});

  final AuthBase auth;
  final Database db;
  String settingValue;
  bool submitted;
  bool isLoading;

  Future<void> updateName(UserApp? user) async {
    try {
      await auth.updateUserName(settingValue);
      if (user != null) {
        user.name = settingValue;
        await db.updateUser(user);
      } else {
        throw Exception('This user doesn\'t seem to exist in the database.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEmail(UserApp? user) async {
    try {
      await auth.updateUserEmail(settingValue);
      if (user != null) {
        user.email = settingValue;
        await db.updateUser(user);
      } else {
        throw Exception('This user doesn\'t seem to exist in the database.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword() async {
    try {
      await auth.updateUserPassword(settingValue);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(UserApp? user) async {
    try {
      await auth.reAuthenticateUser(settingValue);
      if (user != null) {
        await db.deleteUser(user);
      }
      await auth.deleteCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  bool get showError {
    return submitted && !inputIsValidAsText;
  }

  bool get inputIsValidAsEmail {
    return CustomStringValidator.isValid(
        settingValue, TextInputType.emailAddress);
  }

  bool get inputIsValidAsPassword {
    return CustomStringValidator.isValid(
        settingValue, TextInputType.visiblePassword);
  }

  bool get inputIsValidAsText {
    return CustomStringValidator.isValid(settingValue, TextInputType.text);
  }

  void updateSettingValue(String value) => settingValue = value;

  void isSubmitted() => submitted = true;

  SignInType findSignInType() => auth.findSignInType();

  Stream<UserApp> getUserStream() => db.userStream();

  bool canSubmit(SettingType type) {
    switch (type) {
      case SettingType.name:
        return (inputIsValidAsText);
      case SettingType.email:
        return (inputIsValidAsEmail);
      case SettingType.password:
        return (inputIsValidAsPassword);
      default:
        return (inputIsValidAsText);
    }
  }
}

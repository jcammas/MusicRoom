import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_room_app/account/widgets/custom_settings_tile.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/storage_service.dart';
import 'package:music_room_app/widgets/sign_in_type.dart';
import 'package:music_room_app/widgets/validators.dart';
import 'package:music_room_app/services/auth.dart';

class AccountManager with ChangeNotifier {
  AccountManager(
      {required this.auth,
      required this.db,
      required this.storage,
      this.settingValue = '',
      this.submitted = false,
      this.isLoading = false});

  final AuthBase auth;
  final Database db;
  final StorageService storage;
  String settingValue;
  bool submitted;
  bool isLoading;

  Future<void> updateName(UserApp? user) async {
    try {
      await auth.updateUserName(settingValue);
      if (user != null) {
        user.name = settingValue;
        await db.update(user);
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
        await db.update(user);
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

  Future<void> updateAvatar(File pickedImage, UserApp? user) async {
    String url = await storage.saveAvatar(pickedImage: pickedImage);
    if (auth.currentUser != null) {
      await auth.currentUser!.updatePhotoURL(url);
    }
    if (user != null) {
      user.avatarUrl = url;
      await db.update(user);
    } else {
      throw Exception('This user doesn\'t seem to exist in the database.');
    }
  }

  Future<void> reAuthenticateUser() async {
    try {
      await auth.reAuthenticateUser(settingValue);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await db.deleteUser();
      await auth.deleteCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  bool get showError => submitted && !inputIsValidAsText;

  bool get inputIsValidAsEmail =>
      CustomStringValidator.isValid(settingValue, TextInputType.emailAddress);

  bool get inputIsValidAsPassword => CustomStringValidator.isValid(
      settingValue, TextInputType.visiblePassword);

  bool get inputIsValidAsText =>
      CustomStringValidator.isValid(settingValue, TextInputType.text);

  void updateSettingValue(String value) {
    submitted = false;
    settingValue = value;
  }

  void isSubmitted() => submitted = true;

  void notSubmitted() => submitted = false;

  SignInType findSignInType() => auth.findSignInType();

  Stream<UserApp> getUserStream() => db.userStream();

  bool canSubmit(SettingType type) {
    switch (type) {
      case SettingType.name:
        return (inputIsValidAsText);
      case SettingType.email:
        return (inputIsValidAsEmail);
      case SettingType.newPassword:
      case SettingType.oldPassword:
        return (inputIsValidAsPassword);
      default:
        return (inputIsValidAsText);
    }
  }
}

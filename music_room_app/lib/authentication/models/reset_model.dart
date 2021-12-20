import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:music_room_app/authentication/models/validators.dart';
import 'package:music_room_app/services/auth.dart';

enum ResetFormType { signIn, register }

class ResetModel with EmailAndPasswordValidators, ChangeNotifier {
  ResetModel({
    required this.auth,
    this.email = '',
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthBase auth;
  String email;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.sendPasswordResetEmail(email : email);
    } catch (e) {
      updateWith(submitted: false, isLoading: false);
      rethrow;
    }
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        !isLoading;
  }

  bool get showEmailError {
    return submitted && !emailValidator.isValid(email);
  }

  void updateEmail(String email) => updateWith(email: email);

  void updateWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

}

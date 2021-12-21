import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:music_room_app/authentication/models/validators.dart';
import 'package:music_room_app/services/auth.dart';

enum LoginFormType { signIn, register, reset }

class LoginModel with EmailAndPasswordValidators, ChangeNotifier {
  LoginModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = LoginFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthBase auth;
  String email;
  String password;
  LoginFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == LoginFormType.signIn) {
        await auth.signInWithEmail(email: email, password: password);
        // await auth.checkEmailVerified();
      } else if (formType == LoginFormType.register) {
        await auth.createUserWithEmail(email: email, password: password);
      } else if (formType == LoginFormType.reset){
        await auth.sendPasswordResetEmail(email: email);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        (passwordValidator.isValid(password) ||
            formType == LoginFormType.reset) &&
        !isLoading;
  }

  bool get showPasswordError {
    return submitted && !passwordValidator.isValid(password);
  }

  bool get showEmailError {
    return submitted && !emailValidator.isValid(email);
  }

  void updateFormType(LoginFormType formType) => updateWith(
        email: '',
        password: '',
        formType: formType,
        isLoading: false,
        submitted: false,
      );

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    LoginFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}

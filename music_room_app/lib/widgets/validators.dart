import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';

class CustomStringValidator {
  static bool isValid(String value, TextInputType type) {
    bool isValid = true;
    isValid = isValid && value.isNotEmpty;
    if (type == TextInputType.emailAddress) {
      isValid = isValid && EmailValidator.validate(value);
    }
    return isValid;
  }
}

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.title,
    this.obscureText = false,
    this.initialValue,
    this.textInputType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorText,
    this.prefixIcon,
    this.controller,
    this.focusNode,
  }) : super();
  final String title;
  final bool obscureText;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? errorText;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 25, left: 25),
      child: TextFormField(
        keyboardType: textInputType,
        obscureText: obscureText,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: title,
          errorText: errorText,
          prefixIcon: prefixIcon,
        ),
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        focusNode: focusNode,
      ),
    );
  }
}

// decoration: kTextFieldDecoration.copyWith(
// labelText: 'Email',
// hintText: 'test@test.com',
// errorText: model.showEmailError ? 'Email can\'t be empty' : null,
// enabled: model.isLoading == false,
// prefixIcon: const Icon(
// Icons.email,
// color: Color(0XFF072BB8),
// ),
// ),

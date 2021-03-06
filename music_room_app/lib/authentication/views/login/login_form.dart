import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/authentication/views/widgets/login_button.dart';
import 'package:music_room_app/authentication/views/widgets/email_sent_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/text_field_decoration.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:music_room_app/authentication/managers/login_manager.dart';

import '../../../constant_colors.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.manager}) : super(key: key);
  final LoginManager manager;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<LoginManager>(
      create: (_) => LoginManager(auth: auth),
      child: Consumer<LoginManager>(
        builder: (_, manager, __) => LoginForm(manager: manager),
      ),
    );
  }

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String titleText = 'Sign In';
  String buttonText = 'Login';
  String forgotPassword = 'Forgot Password ?';
  String footText = 'Don\'t have an account?';
  String footHeroText = 'Sign up';
  String errorText = 'Ops ! Sign in failed...';

  LoginManager get model => widget.manager;

  void _setTexts() {
    switch (model.formType) {
      case LoginFormType.signIn:
        {
          titleText = 'Sign In';
          buttonText = 'Login';
          forgotPassword = 'Forgot Password ?';
          footText = 'Don\'t have an account?';
          footHeroText = 'Sign up';
          errorText = 'Ops ! Sign in failed...';
        }
        break;

      case LoginFormType.register:
        {
          titleText = 'Sign Up';
          buttonText = 'Create an account';
          forgotPassword = '';
          footText = 'Have an account ?';
          footHeroText = 'Sign in';
          errorText = 'Ops ! Registering failed...';
        }
        break;

      case LoginFormType.reset:
        {
          titleText = 'Reset';
          buttonText = 'Reset Password';
          forgotPassword = '';
          footText = '';
          footHeroText = '';
          errorText = 'Ops ! Reset failed...';
        }
        break;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await model.submit();
      if (model.formType != LoginFormType.signIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const EmailSentSnackBar(),
        );
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      await showExceptionAlertDialog(context, title: errorText, exception: e);
    }
  }

  void _emailEditingComplete() {
    if (model.formType == LoginFormType.reset && model.emailIsValid) {
      _submit();
    } else {
      final newFocus =
          model.emailIsValid ? _passwordFocusNode : _emailFocusNode;
      FocusScope.of(context).requestFocus(newFocus);
    }
  }

  void _toggleResetPassword() => model.updateFormType(LoginFormType.reset);

  void _toggleFormType() {
    model.formType == LoginFormType.signIn
        ? model.updateFormType(LoginFormType.register)
        : model.updateFormType(LoginFormType.signIn);
    _emailController.clear();
    _passwordController.clear();
  }

  GestureDetector _buildFootMessage() {
    return GestureDetector(
      onTap: !model.isLoading ? _toggleFormType : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            footText,
            style: const TextStyle(fontSize: 20, color: primaryColor),
          ),
          const SizedBox(width: 10),
          Hero(
            tag: '1',
            child: Text(
              footHeroText,
              style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          )
        ],
      ),
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Password',
        errorText: model.showPasswordError ? 'Password can\'t be empty' : null,
        enabled: model.isLoading == false,
        prefixIcon: const Icon(
          Icons.lock,
          color: primaryColor,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter password";
        } else {
          return null;
        }
      },
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.showEmailError ? 'Email can\'t be empty' : null,
        enabled: model.isLoading == false,
        prefixIcon: const Icon(
          Icons.email,
          color: primaryColor,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter email";
        } else {
          return null;
        }
      },
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
    );
  }

  Text _buildTitle() {
    return Text(
      titleText,
      style: const TextStyle(
          fontSize: 50, color: primaryColor, fontWeight: FontWeight.w700),
    );
  }

  List<Widget> _buildChildrenReset() {
    _setTexts();
    double sizeHeight = MediaQuery.of(context).size.height;
    return [
      _buildTitle(),
      const SizedBox(height: 30),
      _buildEmailTextField(),
      SizedBox(height: sizeHeight * 0.05),
      LoginButton(
        title: buttonText,
        onPressed: model.canSubmit ? _submit : null,
        color: primaryColor
      ),
    ];
  }

  List<Widget> _buildChildren() {
    _setTexts();
    return [
      _buildTitle(),
      const SizedBox(height: 30),
      _buildEmailTextField(),
      const SizedBox(height: 30),
      _buildPasswordTextField(),
      const SizedBox(height: 60),
      LoginButton(
        title: buttonText,
        onPressed: model.canSubmit ? _submit : null,
        color: primaryColor
      ),
      const SizedBox(height: 20),
      _buildFootMessage(),
      const SizedBox(height: 10),
      TextButton(
        child: Text(
          forgotPassword,
          style: const TextStyle(fontSize: 20, color: primaryColor),
        ),
        onPressed: !model.isLoading ? _toggleResetPassword : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return model.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: model.formType == LoginFormType.reset
                ? _buildChildrenReset()
                : _buildChildren(),
          );
  }
}

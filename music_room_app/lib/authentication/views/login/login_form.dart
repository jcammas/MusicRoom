import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/authentication/views/widgets/login_button.dart';
import 'package:music_room_app/authentication/views/widgets/email_sent_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/constants.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:music_room_app/authentication/managers/login_manager.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.manager}) : super(key: key);
  final LoginManager manager;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<LoginManager>(
      create: (_) => LoginManager(auth: auth),
      child: Consumer<LoginManager>(
        builder: (_, model, __) => LoginForm(manager: model),
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

  LoginManager get manager => widget.manager;

  void _setTexts() {
    switch (manager.formType) {
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
      await manager.submit();
      if (manager.formType != LoginFormType.signIn) {
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
    if (manager.formType == LoginFormType.reset && manager.emailIsValid) {
      _submit();
    } else {
      final newFocus =
          manager.emailIsValid ? _passwordFocusNode : _emailFocusNode;
      FocusScope.of(context).requestFocus(newFocus);
    }
  }

  void _toggleResetPassword() => manager.updateFormType(LoginFormType.reset);

  void _toggleFormType() {
    manager.formType == LoginFormType.signIn
        ? manager.updateFormType(LoginFormType.register)
        : manager.updateFormType(LoginFormType.signIn);
    _emailController.clear();
    _passwordController.clear();
  }

  GestureDetector _buildFootMessage() {
    return GestureDetector(
      onTap: !manager.isLoading ? _toggleFormType : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            footText,
            style: const TextStyle(fontSize: 20, color: Color(0XFF072BB8)),
          ),
          const SizedBox(width: 10),
          Hero(
            tag: '1',
            child: Text(
              footHeroText,
              style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF072BB8)),
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
        errorText: manager.showPasswordError ? 'Password can\'t be empty' : null,
        enabled: manager.isLoading == false,
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0XFF072BB8),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter password";
        }
      },
      onChanged: manager.updatePassword,
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
        errorText: manager.showEmailError ? 'Email can\'t be empty' : null,
        enabled: manager.isLoading == false,
        prefixIcon: const Icon(
          Icons.email,
          color: Color(0XFF072BB8),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter email";
        }
      },
      onChanged: manager.updateEmail,
      onEditingComplete: _emailEditingComplete,
    );
  }

  Text _buildTitle() {
    return Text(
      titleText,
      style: const TextStyle(
          fontSize: 50, color: Color(0XFF072BB8), fontWeight: FontWeight.w700),
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
        onPressed: manager.canSubmit ? _submit : null,
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
        onPressed: manager.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 20),
      _buildFootMessage(),
      const SizedBox(height: 10),
      TextButton(
        child: Text(
          forgotPassword,
          style: const TextStyle(fontSize: 20, color: Color(0XFF072BB8)),
        ),
        onPressed: !manager.isLoading ? _toggleResetPassword : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return manager.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: manager.formType == LoginFormType.reset
                ? _buildChildrenReset()
                : _buildChildren(),
          );
  }
}

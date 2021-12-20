import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD:music_room_app/lib/authentication/views/login/login_form.dart
import 'package:music_room_app/authentication/views/widgets/login_button.dart';
=======
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/views/component/login_signup_button.dart';
import 'package:music_room_app/views/component/show_exception_alert_dialog.dart';
import 'package:music_room_app/views/login/validators.dart';
import 'package:music_room_app/views/login/widgets/reset.dart';
>>>>>>> 3b4f21342eeafc989a2c37c2b37ac00625ebb210:music_room_app/lib/views/login/login_form.dart
import 'package:provider/provider.dart';
import 'package:music_room_app/authentication/views/reset/reset.dart';
import 'package:music_room_app/authentication/views/verify/verify.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/constants.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:music_room_app/authentication/models/login_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.model}) : super(key: key);
  final LoginModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(auth: auth),
      child: Consumer<LoginModel>(
        builder: (_, model, __) => LoginForm(model: model),
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

  LoginModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
<<<<<<< HEAD:music_room_app/lib/authentication/views/login/login_form.dart
    try {
      await model.submit();
      if (model.formType == LoginFormType.register) {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const VerifyScreen(),
        ));
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context,
          title: model.formType == LoginFormType.signIn
              ? 'Ops ! Sign in failed'
              : 'Ops ! Registering failed',
          exception: e);
=======
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == LoginFormType.signIn) {
        await auth.signInWithEmail(email: _email, password: _password);
      } else {
        await auth.createUserWithEmail(email: _email, password: _password);
        await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VerifyScreen(),
            ));
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
        showExceptionAlertDialog(
          context,
          title: _formType == LoginFormType.signIn ? 'Ops ! Sign in failed' : 'Ops ! Registering failed',
          exception : e
        );
    } finally {
      setState(() {
        _isLoading = false;
      });
>>>>>>> 3b4f21342eeafc989a2c37c2b37ac00625ebb210:music_room_app/lib/views/login/login_form.dart
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _resetPassword() async {
<<<<<<< HEAD:music_room_app/lib/authentication/views/login/login_form.dart
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Reset(),
        ));
    Navigator.of(context).pop();
  }
=======
    if (_formType == LoginFormType.signIn) {
      setState(() {
        _submitted = true;
        _isLoading = true;
      });
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Reset(),
            ));
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      }
    }
>>>>>>> 3b4f21342eeafc989a2c37c2b37ac00625ebb210:music_room_app/lib/views/login/login_form.dart

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  GestureDetector _buildFootMessage() {
    final primaryText = model.formType == LoginFormType.signIn
        ? 'Don\'t have an account?'
        : 'Have an account?';
    final secondaryText =
        model.formType == LoginFormType.signIn ? 'Sign up' : 'Sign in';
    return GestureDetector(
      onTap: !model.isLoading ? _toggleFormType : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            primaryText,
            style: const TextStyle(fontSize: 20, color: Color(0XFF072BB8)),
          ),
          const SizedBox(width: 10),
          Hero(
            tag: '1',
            child: Text(
              secondaryText,
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
        errorText: model.showPasswordError ? 'Password can\'t be empty' : null,
        enabled: model.isLoading == false,
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
          color: Color(0XFF072BB8),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter email";
        }
      },
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
    );
  }

  List<Widget> _buildChildren() {
    final primaryText =
        model.formType == LoginFormType.signIn ? 'Login' : 'Create an account';
    final secondaryText =
        model.formType == LoginFormType.signIn ? 'Forgot Password ?' : '';

    return [
      Text(
        model.formType == LoginFormType.signIn ? "Sign In" : "Sign Up",
        style: const TextStyle(
            fontSize: 50,
            color: Color(0XFF072BB8),
            fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 30),
      _buildEmailTextField(),
      const SizedBox(height: 30),
      _buildPasswordTextField(),
      const SizedBox(height: 60),
      LoginButton(
        title: primaryText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 20),
      _buildFootMessage(),
      const SizedBox(height: 10),
      TextButton(
        child: Text(
          secondaryText,
          style: const TextStyle(fontSize: 20, color: Color(0XFF072BB8)),
        ),
        onPressed: !model.isLoading ? _resetPassword : null,
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
            children: _buildChildren(),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/views/component/login_signup_button.dart';
import 'package:music_room_app/views/component/show_alert_dialog.dart';
import 'package:music_room_app/views/login/validators.dart';
import 'package:music_room_app/views/login/widgets/reset.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'verify.dart';

enum LoginFormType { signIn, register }

class LoginForm extends StatefulWidget with EmailAndPasswordValidators {
  LoginForm({Key? key}) : super(key: key);


  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;
  LoginFormType _formType = LoginFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == LoginFormType.signIn) {
        await auth.signInWithEmail(email: _email, password: _password);
      } else {
        await auth.createUserWithEmail(email: _email, password: _password);
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerifyScreen(),
            ));
      }
      Navigator.of(context).pop();
    } catch (e) {
      if (_formType == LoginFormType.signIn) {
        showAlertDialog(
          context,
          title: 'Ops ! Sign in failed',
          content: e.toString(),
          defaultActionText: 'OK',
        );
      } else {
        showAlertDialog(
          context,
          title: 'Ops ! Registering failed',
          content: e.toString(),
          defaultActionText: 'OK',
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _resetPassword() async {
    if (_formType == LoginFormType.signIn) {
      setState(() {
        _submitted = true;
        _isLoading = true;
      });
      try {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Reset(),
            ));
        Navigator.of(context).pop();
      } catch (e) {
        showAlertDialog(
          context,
          title: 'Reset failed',
          content: e.toString(),
          defaultActionText: 'OK',
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == LoginFormType.signIn
          ? LoginFormType.register
          : LoginFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  GestureDetector _buildFootMessage() {
    final primaryText = _formType == LoginFormType.signIn
        ? 'Don\'t have an account?'
        : 'Have an account?';
    final secondaryText =
        _formType == LoginFormType.signIn ? 'Sign up' : 'Sign in';
    return GestureDetector(
      onTap: !_isLoading ? _toggleFormType : null,
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
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0XFF072BB8),
        ),
      ),
      obscureText: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter Password";
        }
      },
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextFormField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
        prefixIcon: const Icon(
          Icons.email,
          color: Color(0XFF072BB8),
        ),
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter Password";
        }
      },
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == LoginFormType.signIn ? 'Login' : 'Create an account';
    final secondaryText =
        _formType == LoginFormType.signIn ? 'Forgot Password ?' : '';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      Text(
        _formType == LoginFormType.signIn ? "Sign In" : "Sign Up",
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
      LoginSignupButton(
        title: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      const SizedBox(height: 20),
      _buildFootMessage(),
      const SizedBox(height: 10),
      TextButton(
        child: Text(
          secondaryText,
          style: const TextStyle(fontSize: 20, color: Color(0XFF072BB8)),
        ),
        onPressed: !_isLoading ? _resetPassword : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(),
          );
  }

  void _updateState() {
    setState(() {});
  }
}

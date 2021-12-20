import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/authentication/views/widgets/login_button.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/authentication/models/reset_model.dart';
import 'package:music_room_app/widgets/constants.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class ResetForm extends StatefulWidget {
  const ResetForm({Key? key, required this.model}) : super(key: key);
  final ResetModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ResetModel>(
      create: (_) => ResetModel(auth: auth),
      child: Consumer<ResetModel>(
        builder: (_, model, __) => ResetForm(model: model),
      ),
    );
  }

  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final TextEditingController _emailController = TextEditingController();

  ResetModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Enter Your Email',
        errorText: model.showEmailError ? 'Email can\'t be empty' : null,
        enabled: model.isLoading == false,
        prefixIcon: const Icon(
          Icons.email,
          color: Color(0XFF072BB8),
        ),
      ),
      validator: (value) =>
      (value!.isEmpty) ? ' Please enter email' : null,
      onChanged: model.updateEmail,
      onEditingComplete: _sendPasswordResetEmail,
    );
  }

  Widget _buildTitle() {
    return const Hero(
      tag: '1',
      child: Text(
        "Reset password",
        style: TextStyle(
            fontSize: 30,
            color: Color(0XFF072BB8),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void _sendPasswordResetEmail() async {
    try {
      await model.submit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0XFF072BB8),
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                'An email has been set, please check your mail inbox to recover your password.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ),
          duration: Duration(seconds: 5),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      await showExceptionAlertDialog(context, title: 'Reset failed', exception: e);
    }
  }

  List<Widget> _buildChildren() {
    double sizeHeight = MediaQuery.of(context).size.height;

    return [
      _buildTitle(),
      const SizedBox(height: 30),
      _buildEmailTextField(),
      SizedBox(height: sizeHeight * 0.05),
      LoginButton(
        title: 'Send request',
        onPressed: model.canSubmit ? _sendPasswordResetEmail : null,
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

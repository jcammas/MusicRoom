import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants.dart';
import '../../component/button.dart';

class Reset extends StatefulWidget {
  const Reset({Key? key}) : super(key: key);

  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String _email;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF072BB8),
        elevation: 0,
      ),
      body: Form(
        key: formkey,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Hero(
                        tag: '1',
                        child: Text(
                          "Reset password",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0XFF072BB8),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          _email = value.toString().trim();
                        },
                        validator: (value) =>
                            (value!.isEmpty) ? ' Please enter email' : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color(0XFF072BB8),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeHeight * 0.05),
                      LoginSignupButton(
                        title: 'Send request',
                        ontapp: () async {
                          _auth.sendPasswordResetEmail(email: _email);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0XFF072BB8),
                              content: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    'An email has been set, please check your boxmail to recover your password.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center),
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

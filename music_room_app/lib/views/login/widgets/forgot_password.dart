import 'package:flutter/material.dart';
import 'package:music_room_app/views/login/login.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0XFF072BB8),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Email',
                style: TextStyle(fontSize: 30, color: Color(0XFF072BB8)),
              ),
              TextFormField(
                style: const TextStyle(color: Color(0XFF072BB8)),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                    color: Color(0XFF072BB8),
                  ),
                  errorStyle: TextStyle(color: Color(0XFF072BB8)),
                  labelStyle: TextStyle(color: Color(0XFF072BB8)),
                  hintStyle: TextStyle(color: Color(0XFF072BB8)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF072BB8)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF072BB8)),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF072BB8)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text(
                  'Send Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF072BB8))),
              ),
              TextButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0XFF072BB8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

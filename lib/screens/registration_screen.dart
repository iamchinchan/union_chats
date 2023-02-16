import 'package:flutter/material.dart';
import 'package:secret_chats/components/custom_text_field.dart';
import 'package:secret_chats/components/round_button.dart';
import 'package:secret_chats/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secret_chats/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const id = 'registration_screen';
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  void initState() {
    print('registration page state object created!');
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    print('registration object deactivated');
  }

  @override
  void dispose() {
    super.dispose();
    print('registration object disposed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'appLogo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              CustomTextField(
                value: email,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                hintText: 'Enter your email',
                color: secondaryButtonColor,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomTextField(
                value: password,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                hintText: 'Enter your password',
                color: secondaryButtonColor,
                icon: Icons.password,
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundButton(
                  onPressed: () async {
                    //Implement registration functionality.
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        print('new user created with values: $newUser');
                        Navigator.pushNamedAndRemoveUntil(
                            context, ChatScreen.id, (route) => false);
                      } else {
                        print('Failed to create new user! Try again');
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                      setState(() {
                        email = '';
                        password = '';
                        showSpinner = false;
                      });
                    }
                  },
                  color: secondaryButtonColor,
                  label: 'Register')
            ],
          ),
        ),
      ),
    );
  }
}

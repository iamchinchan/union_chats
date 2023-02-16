import 'package:flutter/material.dart';
import 'package:secret_chats/components/round_button.dart';
import 'package:secret_chats/constants.dart';
import 'package:secret_chats/screens/chat_screen.dart';
import '../components/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = 'login_screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  void initState() {
    print('login page created right now!');
    super.initState();
  }

  @override
  void deactivate() {
    print('login page deactivated');
    super.deactivate();
  }

  @override
  void dispose() {
    print('login page disposed , totally gone');
    super.dispose();
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
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                hintText: 'Enter your email',
                color: primaryButtonColor,
                icon: Icons.email,
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomTextField(
                value: password,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                hintText: 'Enter your password',
                color: primaryButtonColor,
                icon: Icons.password,
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundButton(
                  onPressed: () async {
                    //Implement login functionality.
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        print('User successfully logged in with value: $user');
                        Navigator.pushNamedAndRemoveUntil(
                            context, ChatScreen.id, (route) => false);
                      } else {
                        print('Log in failed, please try again later');
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
                  color: primaryButtonColor,
                  label: 'Log In')
            ],
          ),
        ),
      ),
    );
  }
}

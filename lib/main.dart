import 'package:flutter/material.dart';
import 'package:secret_chats/screens/welcome_screen.dart';
import 'package:secret_chats/screens/login_screen.dart';
import 'package:secret_chats/screens/registration_screen.dart';
import 'package:secret_chats/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SecretChats());
}

class SecretChats extends StatelessWidget {
  const SecretChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light().copyWith(
          textTheme: const TextTheme().copyWith(
            bodyText2: const TextStyle(color: Colors.black54),
          ),
        ),
        initialRoute: ChatScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          ChatScreen.id: (context) => const ChatScreen(),
        });
  }
}

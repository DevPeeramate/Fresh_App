import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_app/login.dart';
import 'account_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Firebase Auth', style: TextStyle(color: Colors.white)),
        ),
        actions: const [Icon(Icons.help, color: Colors.white)],
        backgroundColor: const Color.fromRGBO(40, 84, 48, 1),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const AccountScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

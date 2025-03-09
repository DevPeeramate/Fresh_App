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
          // กรณีที่กำลังโหลดข้อมูล
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // ถ้าผู้ใช้ล็อกอินอยู่ให้ไปหน้า AccountScreen
          if (snapshot.hasData) {
            return const AccountScreen();
          }
          // ถ้ายังไม่ได้ล็อกอินให้ไปหน้า LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}

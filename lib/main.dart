import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'welcome_screen.dart'; // ให้เริ่มที่หน้า WelcomeScreen
import 'main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ตรวจสอบว่ามี Firebase ถูก initialize ไปแล้วหรือยัง
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      // MainScreen(),
      // WelcomeScreen(), // ให้เริ่มที่ WelcomeScreen
    );
  }
}

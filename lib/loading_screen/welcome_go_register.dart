import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../register.dart';

class LoadingWelcomeGoRegisterScreen extends StatefulWidget {
  const LoadingWelcomeGoRegisterScreen({super.key});

  @override
  State<LoadingWelcomeGoRegisterScreen> createState() => _LoadingWelcomeGoRegisterScreenState();
}

class _LoadingWelcomeGoRegisterScreenState extends State<LoadingWelcomeGoRegisterScreen> {
  @override
  void initState() {
    super.initState();
    // ตั้งเวลาให้โหลด 2 วินาทีแล้วเปลี่ยนหน้าไปยัง RegisterScreen()
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterScreen()), // เปลี่ยนไปยัง RegisterScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(
            255, 255, 211, 174), // Set the background color here
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150, // Adjust the width as needed
                height: 150, // Adjust the height as needed
                child: LottieBuilder.network(
                  'https://lottie.host/3ccc1535-a81e-4e76-8560-7631c1579a33/5qzcCaARe3.json',
                ),
              ),
              SizedBox(
                width: 500, // Adjust the width as needed
                height: 500, // Adjust the height as needed
                child: LottieBuilder.network(
                  'https://lottie.host/d5b96f9c-3d9c-4027-85f1-2454edac2348/qgrCnvfYuA.json',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

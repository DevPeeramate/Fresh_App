import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loading_screen/welcome_go_login.dart';
import 'loading_screen/welcome_go_register.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //----- Top part ------
      appBar: AppBar(
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
      ),

      //----- Content part ------
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Images/welcome_logo.png', height: 275), 
            const SizedBox(height: 20), 

            Text(
              "Relax and shop",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // ✅ ใช้สีหลักของธีม
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Shop online and get groceries\n delivered from stores to your home",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87, // ✅ สีข้อความให้อ่านง่าย
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 ปุ่ม Sign Up
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingWelcomeGoRegisterScreen()), 
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // ✅ ใช้สีหลักของแอป
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // ✅ โค้งมนเพื่อความสวยงาม
                ),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 ปุ่ม Sign In
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingWelcomeGoLoginScreen()), 
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange, width: 2), // ✅ ใช้ขอบสีหลักของธีม
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // ✅ โค้งมนเพื่อความสวยงาม
                ),
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loading_screen/welcome_go_login.dart';
import '/loading_screen/welcome_go_register.dart';

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
      body: Center( // Set Content
        child: Column( // Component
        mainAxisAlignment: MainAxisAlignment.center, //Manage Column Vertical (Y-axis)
          children: [ // Component of child
            Image.asset('assets/Images/welcome_logo.png', height: 275), //add Image in pubspec.yaml
            SizedBox(height: 20), // Distance
            Text("Relax and shop",style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10),
            Text( "Shop online and get groceries\n delivered from stores to your home",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins( // Font Google
              fontSize: 15, // Property of font
            ),
            ),
            SizedBox(height: 30),
            
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingWelcomeGoRegisterScreen()), // ไปหน้า Register
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // สีปุ่ม Sign Up
    foregroundColor: Colors.white, // สีข้อความ
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
  child: Text("Sign Up"),
),

SizedBox(height: 20),

ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingWelcomeGoLoginScreen()), // ไปหน้า Login
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 243, 33, 33), // สีปุ่ม Sign In
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
  child: Text("Sign In"),
),
            


          ],
        ),
      ),
    );
  }
}

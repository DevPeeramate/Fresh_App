import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'welcome_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // ฟังก์ชัน Logout และกลับไปที่หน้า Welcome
  void signUserOut() async {
  await FirebaseAuth.instance.signOut();
  
  // เช็คก่อนว่าผู้ใช้ล็อกอินผ่าน Google หรือไม่
  final GoogleSignIn googleSignIn = GoogleSignIn();
  if (await googleSignIn.isSignedIn()) {
    await googleSignIn.signOut();
  }

  // พาผู้ใช้กลับไปที่หน้า WelcomeScreen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("This is Account Page", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Logged in as: ${user?.email ?? 'No email available'}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

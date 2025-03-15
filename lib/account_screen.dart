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

  // ฟังก์ชัน Logout พร้อม Confirm Dialog
  void confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: signUserOut,
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชัน Logout และกลับไปที่หน้า Welcome
  void signUserOut() async {
    Navigator.pop(context); // ปิด Dialog

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
    String profileImage = user?.photoURL ?? ""; // ดึง URL รูปภาพจาก Firebase

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Account",
          style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // รูปโปรไฟล์ตรงกลาง
          CircleAvatar(
            radius: 50, // ขนาดวงกลม
            backgroundImage: profileImage.isNotEmpty
                ? NetworkImage(profileImage) // แสดงรูปจาก Google หากมี
                : const AssetImage('assets/Images/default_profile.png') as ImageProvider, // แสดงรูป Default
          ),
          const SizedBox(height: 15),

          // แสดงอีเมลของผู้ใช้
          Center(
            child: Text(
              'Logged in as: ${user?.email ?? 'No email available'}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // ปุ่ม Logout พร้อม Confirm Dialog
          ElevatedButton.icon(
            onPressed: confirmSignOut,
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

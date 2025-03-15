// นำเข้าแพ็กเกจที่จำเป็นสำหรับแอปพลิเคชัน
import 'package:flutter/material.dart'; // ใช้สำหรับสร้าง UI ตามแนวทาง Material Design
import 'package:lottie/lottie.dart'; // ใช้สำหรับแสดงภาพเคลื่อนไหวจากไฟล์ JSON (Lottie Animations)
import 'loading_screen/loading_register_go_login.dart'; // นำเข้าไฟล์ที่ใช้สำหรับการเปลี่ยนไปหน้าล็อกอินหลังจากสมัครสมาชิกสำเร็จ
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_screen.dart';

// ✅ สร้างคลาส RegisterScreen ซึ่งเป็น **StatefulWidget**
//    เนื่องจากมีการเปลี่ยนแปลงข้อมูล (State) เช่น การกรอกอีเมล, รหัสผ่าน และยืนยันรหัสผ่าน
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


Future<void> registerWithEmailPassword(BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("Registration Successful: ${userCredential.user!.email}");

    // แสดงข้อความแจ้งเตือน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registration Successful")),
    );

    // หลังจากสมัครเสร็จ ให้ไปหน้าล็อกอิน
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoadingRegisterGoLoginScreen()),
    );
  } on FirebaseAuthException catch (e) {
    // ตรวจสอบข้อผิดพลาดของ Firebase
    String errorMessage = "Registration failed";
    if (e.code == 'weak-password') {
      errorMessage = "The password provided is too weak.";
    } else if (e.code == 'email-already-in-use') {
      errorMessage = "The account already exists for that email.";
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}


// ✅ คลาส _RegisterScreenState ใช้ควบคุมพฤติกรรมของหน้าสมัครสมาชิก
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // ใช้สำหรับระบุฟอร์ม เพื่อช่วยตรวจสอบความถูกต้องของข้อมูลที่กรอก
  String _email = ''; // ตัวแปรสำหรับเก็บค่าอีเมลที่ผู้ใช้กรอก
  String _password = ''; // ตัวแปรสำหรับเก็บค่ารหัสผ่านที่ผู้ใช้กรอก
  String _confirmPassword = ''; // ตัวแปรสำหรับเก็บค่าการยืนยันรหัสผ่าน
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false, //protect user close popup while working
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'No internet connection. Please check your network.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 สร้าง AppBar (แถบด้านบนของแอป)
      appBar: AppBar(
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับอัตโนมัติ
        backgroundColor: Color.fromARGB(255, 230, 75, 14), // กำหนดสีพื้นหลังของ AppBar (สีส้มแดง)
        // 🔹 กำหนดชื่อหน้าสมัครสมาชิก
        title: Text(
          "Register here",
          style: TextStyle(
            fontWeight: FontWeight.bold, // ตั้งค่าตัวหนา
            fontSize: 30, // ขนาดตัวอักษรใหญ่ขึ้น
            color: Colors.white, // ตั้งค่าสีตัวอักษรเป็นสีขาว
          ),
        ),
        centerTitle: true, // จัดตำแหน่ง Title ให้อยู่ตรงกลาง
      ),

      // 🔹 ส่วนเนื้อหาหลักของหน้า (Body)
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 255, 211, 174), // กำหนดสีพื้นหลังของหน้า (สีส้มอ่อน)
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0), // กำหนดระยะห่างภายใน
          child: Center(
            child: Form(
              key: _formKey, // กำหนด Key ให้กับ Form เพื่อใช้ตรวจสอบการกรอกข้อมูล
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10), // เพิ่มระยะห่างด้านบน
        
                  // 🔹 แสดงรูปภาพไอคอนล็อกอินจาก assets
                  Image.asset(
                    'assets/Images/picture_password.png', // โหลดรูปภาพจาก assets
                    width: 200, // ความกว้างของภาพ
                    height: 200, // ความสูงของภาพ
                  ),
        
                  SizedBox(height: 20), // เว้นระยะห่าง
        
                  // 🔹 ช่องกรอกอีเมล
                  Row(
                    children: [
                      // แสดงไอคอนแอนิเมชัน Lottie สำหรับอีเมล
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: LottieBuilder.network(
                          'https://lottie.host/edf801ef-5008-422c-8d65-226534031ed4/vAsEdul2so.json',
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Email'), // ป้ายกำกับ
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email'; // ตรวจสอบว่ากรอกอีเมลหรือยัง
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email = value; // อัปเดตค่าอีเมลเมื่อมีการพิมพ์
                          },
                        ),
                      ),
                    ],
                  ),
        
                  SizedBox(height: 20), // เว้นระยะห่าง
        
                  // 🔹 ช่องกรอกรหัสผ่าน
                  Row(
                    children: [
                      // แสดงไอคอนแอนิเมชัน Lottie สำหรับรหัสผ่าน
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: LottieBuilder.network(
                          'https://lottie.host/3bca2223-a015-4c88-a432-d546d0fe7e1a/3FiSy6Ibzw.json',
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          obscureText: true, // ซ่อนรหัสผ่าน
                          decoration: InputDecoration(labelText: 'Password'), // ป้ายกำกับ
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password'; // ตรวจสอบว่ากรอกรหัสผ่านหรือยัง
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value; // อัปเดตรหัสผ่านเมื่อพิมพ์
                          },
                        ),
                      ),
                    ],
                  ),
        
                  SizedBox(height: 20), // เว้นระยะห่าง
        
                  // 🔹 ช่องกรอกยืนยันรหัสผ่าน
                  Row(
                    children: [
                      // แสดงไอคอนแอนิเมชัน Lottie สำหรับยืนยันรหัสผ่าน
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: LottieBuilder.network(
                          'https://lottie.host/3bca2223-a015-4c88-a432-d546d0fe7e1a/3FiSy6Ibzw.json',
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          obscureText: true, // ซ่อนรหัสผ่าน
                          decoration: InputDecoration(labelText: 'Confirm Password'), // ป้ายกำกับ
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _password) {
                              return 'Passwords do not match'; // ตรวจสอบว่ารหัสผ่านตรงกันหรือไม่
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _confirmPassword = value; // อัปเดตค่าการยืนยันรหัสผ่านเมื่อพิมพ์
                          },
                        ),
                      ),
                    ],
                  ),
        
                  SizedBox(height: 15), // เว้นระยะห่าง
        
                  // 🔹 ปุ่มสมัครสมาชิก
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          registerWithEmailPassword(context, _email, _password);
                        }
                      },
                      child: const Text('Register', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                    ),
                  ),
        
                  SizedBox(height: 15), // เว้นระยะห่าง
        
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: signInWithGoogle,
                      icon: Image.asset("assets/Icons/icon_google.png", height: 20, width: 20),
                      label: const Text("Sign Up with Google"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
        
                  SizedBox(height: 5),
        
                  // ปุ่มเข้าสู่ระบบด้วย Facebook
                  SizedBox(
                    width: 350,
                    child: ElevatedButton.icon(
                      onPressed: () {}, // สามารถเพิ่มฟังก์ชันได้
                       icon: Image.asset("assets/Icons/icon_facebook.png", height: 20, width: 20),
                      label: Text("Sign Up with Facebook"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
        
                  // 🔹 ปุ่มกลับไปหน้าล็อกอิน
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingRegisterGoLoginScreen() // ไปหน้าล็อกอิน
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Login",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

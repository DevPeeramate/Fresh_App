import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_app/loading_screen/loading_login_go_register.dart';
import 'package:fresh_app/welcome_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ฟังก์ชันล็อกอินด้วยอีเมลและรหัสผ่าน
  void signUserIn() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pop(context); // ปิด dialog เมื่อสำเร็จ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen()), // ไปหน้า MainScreen
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

  // ฟังก์ชันล็อกอินด้วย Google
  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut(); // ล้าง session เดิมก่อน
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
      appBar: AppBar(
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
        backgroundColor: Color.fromARGB(255, 230, 75, 14), // กำหนดสีพื้นหลังของ AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ไอคอนปุ่มย้อนกลับ
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()), // กดแล้วกลับไปหน้า HomeScreen
            );
          },
        ),
        title: const Text(
          "Login here",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(
            255, 255, 211, 174), // กำหนดสีพื้นหลังของหน้า (สีส้มอ่อน)
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0), // กำหนดระยะห่างภายใน
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10), // เพิ่มระยะห่างด้านบน

                // 🔹 แสดงรูปภาพไอคอนล็อกอินจาก assets
                Image.asset(
                  'assets/Images/picture_password.png', // โหลดรูปภาพจาก assets
                  width: 200, // ความกว้างของภาพ
                  height: 200, // ความสูงของภาพ
                ),

                SizedBox(height: 20), // เว้นระยะห่าง
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: LottieBuilder.network(
                        'https://lottie.host/edf801ef-5008-422c-8d65-226534031ed4/vAsEdul2so.json',
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your email' : null,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 20), // เว้นระยะห่าง

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: LottieBuilder.network(
                        'https://lottie.host/3bca2223-a015-4c88-a432-d546d0fe7e1a/3FiSy6Ibzw.json',
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 25), // เว้นระยะห่าง

                SizedBox(
                  width: 100,  //350
                  child: ElevatedButton(
                    onPressed: signUserIn,
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                    // icon: Image.asset("assets/Icons/icon_google.png", height: 20, width: 20),
                    label: const Text("Sign in with Google"),
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
                    label: Text("Sign in with Facebook"),
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
                        builder: (context) => LoadingLoginGoRegisterScreen() // ไปหน้าล็อกอิน
                      ),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Sign Up",
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
    );
  }
}
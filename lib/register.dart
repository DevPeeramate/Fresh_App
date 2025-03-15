import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  
import 'loading_screen/loading_register_go_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); 
  String _email = ''; 
  String _password = ''; 
  String _confirmPassword = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
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
      appBar: AppBar(
        automaticallyImplyLeading: false, //close back botton
        backgroundColor: const Color.fromARGB(255, 230, 75, 14),
        title: const Text(
          "Register here",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 211, 174), 
        child: SafeArea(
          child: Column(
            children: [
              Expanded( // expand full container
                child: SingleChildScrollView( //scrolling screen
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 30), //set padding
                    child: Form(
                      key: _formKey, 
                      child: Column( 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[ //list of widget
                          const SizedBox(height: 10),
                          
                          Image.asset(
                            'assets/Images/picture_password.png', 
                            width: 200, 
                            height: 200, 
                          ),

                          const SizedBox(height: 20),


                          Row(
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
                                  decoration: const InputDecoration(labelText: 'Email'),
                                  validator: (value) { //call back function
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email'; 
                                    }
                                    return null;
                                  },
                                  onChanged: (value) { //call back function
                                    _email = value; 
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),


                          Row(
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
                                  obscureText: true, 
                                  decoration: const InputDecoration(labelText: 'Password'), 
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _password = value; 
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Row(
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
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _password) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _confirmPassword = value; 
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: 250, 
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  ScaffoldMessenger.of(context).showSnackBar( 
                                    const SnackBar(content: Text('Registering...')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Register', style: TextStyle(fontSize: 16)),
                            ),
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {  
                                signInWithGoogle();
                              },
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

                          const SizedBox(height: 5),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {  
                                // TODO: Sign In with Facebook
                              },
                              icon: Image.asset("assets/Icons/icon_facebook.png", height: 20, width: 20),
                              label: const Text("Sign Up with Facebook"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoadingRegisterGoLoginScreen(),
                                ),
                              );
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(fontSize: 13, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

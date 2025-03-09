import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kenyan_game/views/wlecome_page.dart';

import '../auth.dart';
import '../global.dart';
import '../progress.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password1 = TextEditingController();
  final TextEditingController _password2 = TextEditingController();
  //final GoogleSignIn _googleSignIn = GoogleSignIn(); // Initialize GoogleSignIn instance

  Future<void> _signInWithGoogle() async {
    Dialogs().showLoadingDialog("Waiting for google...");
    Auth().signInWithGoogle(registerCallback);
  }

  Future<void> signUp() async{
    String email = _email.text.trim();
    String password = _password1.text.trim();
    String password2 = _password2.text.trim();
     if(password == password2){
       Dialogs().showLoadingDialog("Please wait...");
       Auth().signUpWithEmailPassword(email.split('@')[0],email, password, registerCallback);
     }else {
        Dialogs().showSnackBar("password not matching");
     }
  }

  void registerCallback(bool isSuccess, String message){
    Navigator.of(navigatorKey.currentContext!).pop();
    if(isSuccess){
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }else{
      Dialogs().showSnackBar(message);
    }
    setState(() {
      _email.clear();
      _password1.clear();
      _password2.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // Orange background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // "Sign Up" Text
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Email TextField
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password TextField
                TextField(
                  obscureText: !_isPasswordVisible,
                  controller: _password1,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password TextField
                TextField(
                  obscureText: !_isConfirmPasswordVisible,
                  controller: _password2,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingPage()));
                    signUp();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Black background color
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red, // Google brand color
                  ),
                  label: const Text(
                    "Sign Up with Google",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Text
                GestureDetector(
                  onTap: () {
                    // Navigate to login page
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(
                        fontFamily: "Pacifico",
                        fontSize: 18,
                        color: Colors.white, // White color for the initial text
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: const TextStyle(
                            fontFamily: "Pacifico",
                            color: Colors.black, // Black color for the "Login" text
                            decoration: TextDecoration.underline, // Optional underline for emphasis
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
                            },
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

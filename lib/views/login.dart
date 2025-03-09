import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kenyan_game/global.dart';
import 'package:kenyan_game/auth.dart';
import 'package:kenyan_game/views/landing_page.dart';
import 'package:kenyan_game/views/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kenyan_game/views/wlecome_page.dart';
import '../progress.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false; // Toggle visibility for password field
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  Future<void> _login() async{
    String email = _emailController.text;
    String password = _passwordController.text;
    Dialogs().showLoadingDialog("Please wait...");
    Auth().signInWithEmailPassword(email, password, loginCallback);
  }
  Future<void> _signInWithGoogle() async {
    Dialogs().showLoadingDialog("Waiting for google...");
    Auth().signInWithGoogle(loginCallback);
  }
  Future<void> _sendResetLink(String email) async {
    if(email.isNotEmpty){
      Dialogs().showLoadingDialog("Please wait.");
      Auth().sendPasswordResetEmail(email, sendLinkCallback);
    }
  }
  void sendLinkCallback(bool isSuccess, String message){
    Navigator.of(navigatorKey.currentContext!).pop();
    Dialogs().showSnackBar(message);
    if(isSuccess){
      Navigator.of(navigatorKey.currentContext!).pop();
    }
    setState(() {
      emailController.clear();
    });
  }
  void loginCallback(bool isSuccess, String message){
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
      _emailController.clear();
      _passwordController.clear();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // Orange background color
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100), // Space at the top

            // Login Heading
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),

            // Email Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                obscureText: !_isPasswordVisible,
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Forgot Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return SingleChildScrollView(
                              child: AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "Forgot Password",
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        hintText: "Please enter your email",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Handle sending email logic here
                                      _sendResetLink(emailController.text);
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Send"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Login Button
            ElevatedButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingPage()));
                _login();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Black background
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),



// Google Sign-In Button
      ElevatedButton.icon(
      onPressed: () {
      // Add Google Sign-In logic here
        _signInWithGoogle();
    },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black),
        ),
      ),
      icon: FaIcon(
        FontAwesomeIcons.google,
        color: Colors.red,
        size: 24,
      ),
      label: const Text(
        "Sign In With Google",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    ),

    const SizedBox(height: 20),

            // "Don't have an account? Sign Up"
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(
                  fontFamily: "Pacifico",
                  fontSize: 18,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: "Sign Up",
                    style: const TextStyle(
                      fontFamily: "Pacifico",
                      fontSize: 18,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:kenyan_game/subscription.dart';
import 'package:kenyan_game/views/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../auth.dart';
import '../global.dart';
import '../progress.dart';
import 'anonymous_page.dart';
import 'landing_page.dart';



class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _signInAnonymously() async {
    Dialogs().showLoadingDialog("Please wait...");
    Auth().signInAnonymously(signInCallBack);
  }

  Future<void> _signInWithGoogle() async {
    Dialogs().showLoadingDialog("Signing in with Google...");
    Auth().signInWithGoogle(signInCallBack);
  }

  void signInCallBack(bool isSuccess, String message) {
    Navigator.of(navigatorKey.currentContext!).pop(); // Close loading dialog
    if (isSuccess) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.isAnonymous) {
        // Navigate to AnonymousPage if signed in anonymously
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => AnonymousPage()),
        );
      } else {
        // Navigate to LandingPage for other sign-ins
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }
    } else {
      Dialogs().showSnackBar(message); // Show error message if login fails
    }
  }


  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.orange, // Orange background color
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated Circular Avatar at the top
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: const CircleAvatar(
                  radius: 60, // Size of the circular avatar
                  backgroundImage: AssetImage('assets/images/funtime.png'), // Replace with your asset image path
                  backgroundColor: Colors.white, // Background color in case image doesn't load
                ),
              ),

              const SizedBox(height: 20), // Spacing between avatar and text

              // "WELCOME TO KENYA@50" text with animation
              BounceInDown(
                duration: const Duration(milliseconds: 1200),
                child: const Text(
                  "WELCOME TO\nFunTime",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

              ),

              const SizedBox(height: 50), // Space between the text and buttons

              // Show different buttons based on whether the user is signed in
              if (_user == null) ...[
                // Animated "Sign Up" button
                SlideInLeft(
                  duration: const Duration(milliseconds: 1300),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10, // Add elevation to the button
                      backgroundColor: Colors.black, // Black background color
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign Up/In',
                      style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                    ),
                  ),
                ),

                const SizedBox(height: 15), // Space between Sign Up and Google Sign-In

                // Google Sign-In Button
                SlideInLeft(
                  duration: const Duration(milliseconds: 1300),
                  child: OutlinedButton.icon(
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
                ),

                const SizedBox(height: 20), // Space between the two buttons

                // Animated "Proceed Without Sign Up" button
                SlideInRight(
                  duration: const Duration(milliseconds: 1400),
                  child: ElevatedButton(
                    onPressed: () {
                      // Sign in anonymously
                      _signInAnonymously();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10, // Add elevation to the button
                      backgroundColor: Colors.black, // Black background color
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Proceed Without Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                    ),
                  ),
                ),
              ] else...[
                // "Continue" button for signed-in users
                FutureBuilder<bool>(
                  future: SubscriptionService().isSubscriptionExpired(_user), // Async function call
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator()); // Show loading while waiting
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Error checking subscription status"));
                    }

                    bool isExpired = snapshot.data ?? true;

                    if (isExpired) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // "Play Free With Ads" button
                          SlideInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LandingPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Play Free With Ads',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // "Pay 24/=. No Ads for 24hrs" button
                          PaymentButtonWithHint(),

                        ],
                      );
                    } else {
                      // If subscription is active
                      return SlideInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LandingPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 10, // Add elevation to the button
                            backgroundColor: Colors.black, // Black background color
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
              const SizedBox(height: 50), // Spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}

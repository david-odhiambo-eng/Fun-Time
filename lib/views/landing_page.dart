import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:kenyan_game/views/login.dart';
import 'package:kenyan_game/views/payment_page.dart';
import 'package:kenyan_game/views/team_selection.dart';
import 'package:kenyan_game/views/wlecome_page.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for audio playback
import 'package:url_launcher/url_launcher.dart';
import 'instructions.dart';
import 'marking_page.dart';
import 'package:flutter/services.dart';

class LandingPage extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  LandingPage({super.key});

  // Function to play the pop sound
  void _playPopSound() async {
    try {
      await _audioPlayer.play(AssetSource('audios/loud-pop-sound-effect.mp3'));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Logout dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();

                // Perform logout logic
                await FirebaseAuth.instance.signOut();

                // Navigate to WelcomePage and clear navigation stack
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false, // Remove all previous routes
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to WelcomePage on back press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: Colors.orange, // Background color
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                FadeInDown(
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Welcome, let's play together",
                      style: TextStyle(
                        fontFamily: "SmoochSans-VariableFont_wght.ttf",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Main Card
                ZoomIn(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          "FunTime",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Subtitle
                        Text(
                          "LET'S SHARE LOVE AND JOY, HOW MUCH DO YOU KNOW ABOUT KENYA?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "SmoochSans-VariableFont_wght.ttf",
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Emoji
                        Text(
                          "😜",
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Play Button
                Bounce(
                  infinite: true,
                  child: IconButton(
                    icon: const Icon(Icons.play_circle_fill),
                    iconSize: 80,
                    color: Colors.green,
                    onPressed: () {
                      _playPopSound(); // Play the pop sound when pressed
                      // Show dialog when the play button is pressed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white, // Match background color
                            title: const Text(
                              "Choose an Option",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // "Play With My Team" button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      backgroundColor: Colors.black, // Text color
                                    ),
                                    onPressed: () {
                                      // Navigate directly to the TeamSelectionPage
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => TeamSelectionPage()),
                                      );
                                    },
                                    child: const Text("Start Game With My Team", style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                                  ),

                                  const SizedBox(height: 20),
                                  // "Join Via Code" button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("This feature will be enabled in our next update",
                                          style: TextStyle(
                                            fontFamily: "SmoochSans-VariableFont_wght.ttf",
                                          ),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: const Text("See Screen", style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                                  ),

                                  const SizedBox(height: 20),
                                  // "Join To Record Points" button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.orange,
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MarkingPage()));
                                    },
                                    child: const Text("Record Points", style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // Positioned Settings Icon with Dropdown

            Positioned(
              top: 50,
              left: 20,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.settings, color: Colors.black, size: 30),
                onSelected: (value) {
                  if (value == "Logout") {
                    _showLogoutDialog(context);
                  } else if (value == "Pay 24/=. No Ads for 24hrs") {
                    // Handle the "Pay 24/=. No Ads for 24hrs" selection
                  } else if (value == "Get our other apps") {
                    // Handle the "Get our other apps" selection
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: "Pay 24/=. No Ads for 24hrs",
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentPage()));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Pay 24/=. No Ads for 24hrs", style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Logout",
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showLogoutDialog(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Logout", style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Get our other apps",
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Get our other apps",
                          style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Contact Developers",
                      child: TextButton(
                        onPressed: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => DeveloperContactPage()));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Contact Developers",
                          style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Join Our Community",
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final Uri whatsappUrl = Uri.parse("https://chat.whatsapp.com/F5NFBRQRkCE4lakjDvG8i7");

                          if (await canLaunchUrl(whatsappUrl)) {
                            await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Could not open WhatsApp group link")),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Join Our Community",
                          style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Feedback",
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final Uri url = Uri.parse("https://docs.google.com/forms/d/1pjHQUhjHQ0G1ZJKYk2WrPICqN_bDw-xlTXxcsDl9Tvw/edit");
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $url';
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text(
                          "Feedback",
                          style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf"),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Share our App",
                      child: TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: "https://play.google.com/store/apps/details?id=com.kenyaatfifty.app"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Link copied to clipboard",
                              style: TextStyle(
                                fontFamily: "SmoochSans-VariableFont_wght.ttf",
                              ),
                            )),
                          );
                        },
                        icon: const Icon(Icons.copy, color: Colors.white),
                        label: const Text("Share this App",
                          style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf",),),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ),



            // Positioned "How To Play" button at the top-right corner
            Positioned(
              top: 50,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black, // Set text color to white
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InstructionsPage()));
                },
                child: const Text("How To Play"), // Button label
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:kenyan_game/views/rules_page.dart';
import 'package:kenyan_game/views/share_screen.dart';
import 'package:kenyan_game/views/team_selection.dart';
import 'marking_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        "KENYA@50",
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
                    // Show dialog when the play button is pressed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.orange, // Match background color
                          title: const Text(
                            "Choose an Option",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                                    // Show the dropdown for sharing screen
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.orange,
                                          title: const Text(
                                            "Share Screen Option",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          content: SizedBox(
                                            width: double.maxFinite, // Ensure the content takes available width
                                            child: DropdownButton<String>(
                                              isExpanded: true, // Makes the dropdown take the full width
                                              items: const [
                                                DropdownMenuItem(
                                                  child: Text(
                                                    "Share Screen With Opponent Teams",
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                  value: "Share Screen With Opponent Teams",
                                                ),
                                              ],
                                              onChanged: (String? value) {
                                                if (value == "Share Screen With Opponent Teams") {
                                                  // Navigate to RollDicePage when the option is selected
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => TeamSelectionPage(),
                                                    ),
                                                  );
                                                }
                                              },
                                              hint: const Text(
                                                "Select an option",
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Start Game With My Team"),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.orange, // Text color
                                    backgroundColor: Colors.black, // Button background color
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TeamSelectionPage()));
                                  },
                                  child: const Text("Resume Game With My Team"),
                                ),
                                const SizedBox(height: 20),
                                // "Join Via Code" button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ShareScreen()));
                                  },
                                  child: const Text("Join Via Code"),
                                ),
                                const SizedBox(height: 20),
                                // "Join To Record Points" button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MarkingPage()));
                                  },
                                  child: const Text("Join To Record Points"),
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

          // Positioned "How To Play" button at the top-right corner
          Positioned(
            top: 50,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black, // Set text color to white
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding
              ),

              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RulesPage() ));
              },
              child: const Text("How To Play"), // Button label
            ),
          ),
        ],
      ),
    );
  }
}

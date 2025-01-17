import 'package:flutter/material.dart';
import 'generate_words.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen height and width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.orange, // Set the background color to orange
      body:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Ensure the child widgets are centered horizontally
              children: [
                // Text "Kenya@50" at the top with extra padding
                const Padding(
                  padding: EdgeInsets.only(top: 35.0, left: 16.0, right: 16.0), // Added top padding
                  child: Text(
                    "Kenya@50",
                    style: TextStyle(
                      fontSize: 32, // Increase the font size for prominence
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White color for text
                    ),
                  ),
                ),

                // Main Card with Game Content
                Center(
                  child: Card(
                    elevation: 10, // Increased elevation for stronger shadow effect
                    shadowColor: Colors.black.withOpacity(0.3), // Custom shadow color with opacity
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Slightly increased border radius for a more stylish look
                    ),
                    child: Container(
                      height: screenHeight * 0.7, // Adjusted height
                      width: screenWidth * 0.9, // 90% of screen width
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: Text(
                          'Game Content Goes Here',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10), // Spacing between the card and the button

                // "Load Card" button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black background color
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Load Screen',
                      style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                    ),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),

    );
  }
}

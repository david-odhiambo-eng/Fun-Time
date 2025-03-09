import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For playing sound effects
import 'package:kenyan_game/views/rule_four.dart';


import '../ads_manager.dart'; // Import your next page

class RulesPageThree extends StatefulWidget {
  const RulesPageThree({super.key});

  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPageThree>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Define a scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPopSoundAndNavigate() async {
    try {
      // Play the audio file
      _audioPlayer.play(AssetSource('audios/loud-pop-sound-effect.mp3'));

      // Navigate to the next page immediately
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RulesPageFour()),
      );
    } catch (e) {
      // Handle any errors, e.g., audio file not found
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Title
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'RULE 3',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40,),

                // Description with black background and animation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '"See Screen"\n'
                              '1. "This Option is explicitly for Teams that are NOT playing the game(Opponents)"\n'
                              '2. "The playing Team will provide a code"\n'
                              '3. "This code enables you watch along on your phones as the other team plays"\n'
                          ,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "SmoochSans-VariableFont_wght.ttf",
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),

                // Emojis and Bottle
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Text("😜", style: TextStyle(fontSize: 40)),
                        ),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Text("😎", style: TextStyle(fontSize: 40)),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.smartphone, size: 120, color: Colors.black),
                        Transform.rotate(
                          angle: 0.2,
                          child: const Icon(
                            Icons.casino,
                            size: 60,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Text("😍", style: TextStyle(fontSize: 40)),
                        ),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Text("😜", style: TextStyle(fontSize: 40)),
                        ),
                      ],
                    ),
                  ],
                ),

                // Play Button
                ElevatedButton(
                  onPressed: _playPopSoundAndNavigate,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                // Add the Ad Section at the Bottom
                const SizedBox(height: 30), // Space before the ad
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 50, // Adjust based on your ad size
                    width: double.infinity,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: AdManager.getBannerAd(), // Display the banner ad
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

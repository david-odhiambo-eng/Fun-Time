import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For playing sound effects
import 'package:kenyan_game/views/rule_three.dart';

class TipsPage extends StatefulWidget {
  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<TipsPage>
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
        MaterialPageRoute(builder: (context) => const RulesPageThree()),
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
          padding: const EdgeInsets.only(top:40),
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
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'TIPS',
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
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '"Choice of number of phones"\n\n'
                              '1. ALL TEAMS CAN USE A SINGLE PHONE TO PLAY AND SHARE SCREEN TO THE OPPONENTS FOR BETTER ENGAGEMENT',
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
                const SizedBox(height: 40,),

                // Description with black background and animation
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   child: AnimatedContainer(
                //     duration: Duration(seconds: 2),
                //     curve: Curves.easeInOut,
                //     padding: EdgeInsets.all(40),
                //     decoration: BoxDecoration(
                //       color: Colors.black,
                //       borderRadius: BorderRadius.circular(20),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.3),
                //           spreadRadius: 2,
                //           blurRadius: 10,
                //           offset: Offset(0, 4),
                //         ),
                //       ],
                //     ),
                //     child: Text(
                //       'If the game is played without adding names, the players must sit in a circle and rotate the bottle so that it points at them.',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         fontSize: 16,
                //         color: Colors.white,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 40,),

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
              ],
            ),
          ),
        ),

      ),
    );
  }
}

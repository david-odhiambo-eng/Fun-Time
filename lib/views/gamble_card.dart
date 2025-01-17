import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenyan_game/views/team_selection.dart';
import 'generate_words.dart';

class GambleCardScreen extends StatefulWidget {
  @override
  _BlackCardScreenState createState() => _BlackCardScreenState();
}

class _BlackCardScreenState extends State<GambleCardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  late FlutterTts _flutterTts;

  int _counter = 50;
  late Timer _timer;

  String dynamicText = "You will be guided on the instructions shortly... Chonjo!!";

  @override
  void initState() {
    super.initState();

    // Initialize Text-to-Speech
    _flutterTts = FlutterTts();

    // Animation for "BLACK CARD"
    _controller = AnimationController(
      duration: Duration(seconds: 50),
      vsync: this,
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.green, end: Colors.grey[800])
        .animate(_controller);

    // Timer countdown
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;

          // Announce specific milestones
          if (_counter == 30) {
            _speak("30 seconds remaining");
          } else if (_counter == 10) {
            _speak("10 seconds remaining");
          } else if (_counter == 1) {
            _speak("Time is up! Time is up! Stop");
          }
        });
      } else {
        _timer.cancel();
      }
    });

    // Simulate dynamic text change (could be replaced by Firebase later)
    Timer(Duration(seconds: 5), () {
      setState(() {
        dynamicText = "New instructions coming up... Stay tuned!";
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _flutterTts.stop(); // Stop any ongoing speech
    super.dispose();
  }

  // Text-to-Speech function
  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Top bar with "Kenya@50" and emoji
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kenya@50',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _counter % 2 == 0 ? 0.1 : -0.1,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      '😜',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // "SUPREME COURT" button
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _animation.value,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'GAMBLE CARD',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            // Middle card with dynamic instructions text and animation + elevation
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              padding: EdgeInsets.all(20),
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                color: _animation.value,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  dynamicText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Black container below the black card, containing emoji and timer
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedRotation(
                    turns: _counter % 2 == 0 ? 0.1 : -0.1,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      '🙂',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ensures icons stay close to each other
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GenerateWordsPage()),
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                                size: 50,
                              ),
                            ),
                            SizedBox(width: 16), // Add spacing between the icons
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TeamSelectionPage()),
                                );
                              },
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.green,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),),

      ),
    );
  }
}

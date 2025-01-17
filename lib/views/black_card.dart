import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenyan_game/views/team_selection.dart';

class BlackCardScreen extends StatefulWidget {
  @override
  _BlackCardScreenState createState() => _BlackCardScreenState();
}

class _BlackCardScreenState extends State<BlackCardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  int _counter = 50;
  late Timer _timer;
  final FlutterTts _flutterTts = FlutterTts();

  // List of dynamic words
  List<String> words = List.generate(10, (index) => 'Random Word ${index + 1}');

  @override
  void initState() {
    super.initState();

    // Initialize TTS
    _flutterTts.setSpeechRate(0.5); // Adjust speech rate if needed
    _flutterTts.setPitch(1.0); // Adjust pitch if needed

    // Animation for "BLACK CARD"
    _controller = AnimationController(
      duration: Duration(seconds: 25),
      vsync: this,
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.black, end: Colors.grey[800]).animate(_controller);

    // Timer countdown
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });

        // Voice alerts at specific times
        if (_counter == 30) {
          _speak("30 seconds remaining");
        } else if (_counter == 10) {
          _speak("10 seconds remaining");
        } else if (_counter == 1) {
          _speak("Time is up! Time is up! Stop");
        }
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Top bar with "Round x/y" and emoji
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
              SizedBox(height: 20,),

              // "BLACK CARD" button
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
                        'BLACK CARD',
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
              SizedBox(height: 30,),

              // Middle card with numbered random words and animation + elevation
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(words.length, (index) {
                    return Text(
                      '${index + 1}. ${words[index]}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 30,),

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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamSelectionPage()));
                            },
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.green,
                              size: 50,
                            ),
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
          ),
        ),

      ),
    );
  }
}

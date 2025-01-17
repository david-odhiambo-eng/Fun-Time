import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenyan_game/views/team_selection.dart';

class SupremeCourtScreen extends StatefulWidget {
  @override
  _BlackCardScreenState createState() => _BlackCardScreenState();
}

class _BlackCardScreenState extends State<SupremeCourtScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  int _counter = 50;
  late Timer _timer;
  late FlutterTts _flutterTts;

  // Placeholder dynamic text
  String dynamicText = "You will be guided on the instructions shortly... Chonjo!!";

  @override
  void initState() {
    super.initState();

    // Initialize FlutterTTS
    _flutterTts = FlutterTts();

    // Animation for "BLACK CARD"
    _controller = AnimationController(
      duration: Duration(seconds: 50),
      vsync: this,
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.blue, end: Colors.grey[800])
        .animate(_controller);

    // Timer countdown
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
          _announceTime(_counter); // Announce specific intervals
        });
      } else {
        _timer.cancel();
        _speak("Time is up! Time is up! Stop");
      }
    });

    // Simulate dynamic text change
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
    _flutterTts.stop(); // Stop TTS when the widget is disposed
    super.dispose();
  }

  // Announce time intervals
  void _announceTime(int counter) {
    if (counter == 30) {
      _speak("30 seconds remaining");
    } else if (counter == 10) {
      _speak("10 seconds remaining");
    } else if (counter == 1) {
      _speak("Time is up! Time is up! Stop");
    }
  }

  // Speak function using FlutterTTS
  Future<void> _speak(String message) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(message);
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
                        'SUPREME COURT',
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
                          scale: Tween<double>(begin: 1.0, end: 1.2)
                              .animate(
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

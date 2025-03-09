import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenyan_game/views/team_selection.dart';

import '../ads_manager.dart';
import '../global.dart';

class GenerateWordsPage extends StatefulWidget {
  final int teamNo;

  const GenerateWordsPage({Key? key, required this.teamNo}) : super(key: key);

  @override
  _GenerateWordsPageState createState() => _GenerateWordsPageState();
}

class _GenerateWordsPageState extends State<GenerateWordsPage> {
  final List<TextEditingController> _controllers = List.generate(
    10,
        (_) => TextEditingController(),
  );

  final List<String> _hints = [
    "Law",
    "Swahili Sanifu",
    "Engineering",
    "Sheng",
    "Trending Topic",
    "Medicine",
    "Fashion",
    "Politics",
    "Geography",
    "Entertainment",
  ];

  int _counter = 50;
  bool _isTimerRunning = false;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    // Delay the speech by 2 seconds after navigation
    Future.delayed(const Duration(seconds: 2), () {
      _speak(
          "Hand over the phone to the opponent team to enter words for you. Once they’re done, take it back and start the timer to continue the game");
    });
  }

  /// Sends the words to Firestore with numbered keys "1" to "10"
  Future<void> _sendWordsToFirebase() async {
    // Create a Map with keys as "1", "2", ..., "10"
    Map<String, String> numberedWords = {};
    for (int i = 0; i < _controllers.length; i++) {
      numberedWords['${i + 1}'] = _controllers[i].text.trim();
    }

    // Only send if at least one field is non-empty
    if (numberedWords.values.every((word) => word.isEmpty)) return;

    try {
      await FirebaseFirestore.instance.collection('games').add({
        'teamNo': widget.teamNo,
        'words': numberedWords,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Words saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving words: $e')),
      );
    }
  }

  void _startTimer() {
    if (_isTimerRunning) return;

    setState(() {
      _isTimerRunning = true;
    });

    Future.doWhile(() async {
      if (_counter <= 0) {
        await _speak("Time is up! Time is up! Stop");
        setState(() {
          _isTimerRunning = false;
        });
        return false;
      }

      if (_counter == 48) {
        // You can add a custom announcement here if needed.
      } else if (_counter == 30) {
        await _speak("30 seconds remaining");
      } else if (_counter == 10) {
        await _speak("10 seconds remaining");
      } else if (_counter == 1) {
        await _speak("Time is up! Time is up! Stop");
      }

      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _counter--;
      });

      return true;
    });
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double listHeight = screenHeight * 0.6; // Reserve 60% of screen for the list

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.orange,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Text(
                    "FunTime",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[900],
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Timer & Play Button Section
                  GestureDetector(
                    onTap: () async {
                      // If timer is still running, do nothing
                      if (_counter > 0) {
                        if (!_isTimerRunning) {
                          // Send words to Firebase
                          await _sendWordsToFirebase();
                          // Then start the timer
                          _startTimer();
                        }
                      } else {
                        // When timer finishes, show ad and navigate
                        int teamNo = 1; // Replace with actual team number if available
                        int currentRound = database.getTeamRound(teamNo);
                        if (currentRound % 1 == 0) {
                          AdManager.showInterstitialAd();
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamSelectionPage(),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Timer Circle
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$_counter',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Play Button (visible only when timer is not running)
                        AnimatedOpacity(
                          opacity: _isTimerRunning ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Instruction Text
                  const Text(
                    "Hand the phone to the opposing team to enter the words. Once done, start the timer and continue the game.",
                    style: TextStyle(
                      fontFamily: "SmoochSans-VariableFont_wght.ttf",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // List of TextFields Section
                  Container(
                    height: listHeight,
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            style: const TextStyle(
                              fontFamily: "SmoochSans-VariableFont_wght.ttf",
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              hintText: _hints[index],
                              hintStyle:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

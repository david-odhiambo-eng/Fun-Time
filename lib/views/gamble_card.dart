import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenyan_game/views/team_selection.dart';

import '../ads_manager.dart';
import '../database.dart';
import '../global.dart';
import 'generate_words.dart';

class GambleCardScreen extends StatefulWidget {
  final int teamNo;
  const GambleCardScreen({super.key, required this.teamNo});
  @override
  _BlackCardScreenState createState() => _BlackCardScreenState();
}

class _BlackCardScreenState extends State<GambleCardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  late FlutterTts _flutterTts;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<String> usedGamble;
  late List<Map<String, dynamic>> gambleCards;

  int _counter = 50;
  late Timer _timer;

  String dynamicText = ""; // Dynamic text to display
  int _currentTextIndex = 0; // Tracks the current card index

  // Emoji splash
  bool showEmojis = true;
  late int teamNo;
  // Local data to simulate Firebase text data
  List<Map<String, dynamic>> localTextData = [
    {
      "instructions":
      "No instructions.",
      "task":
      "No task",
      "answer": "None"
    }
    // Add more cards as needed
  ];



  @override
  void initState() {
    super.initState();
    gambleCards = Database().getCards(gamble: true);
    usedGamble = usedGambleCards;

    if (gambleCards.isNotEmpty) {
      Random random = Random();
      Map<String, dynamic> selectedItem =
      gambleCards[random.nextInt(gambleCards.length)];
      setState(() {
        dynamicText = '''
        Instructions:
        ${selectedItem["instructions"]}
        
        Task:
        ${selectedItem["task"]}
        
        Price:
        ${selectedItem["price"]}
        
        Answer:
        ${selectedItem["answer"]}
        ''';

      });
      usedGambleCards.add(selectedItem["card_id"]);
    } else {
      _updateDynamicText();
    }
    // Initialize Text-to-Speech
    _flutterTts = FlutterTts();
    teamNo = widget.teamNo;
    // Animation for "BLACK CARD"
    _controller = AnimationController(
      duration: Duration(seconds: 50),
      vsync: this,
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.green, end: Colors.grey[800]).animate(_controller);

    // Timer countdown
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;

          if (_counter == 40) {
            // Trigger UI update to change icon color
          }

          if (_counter == 48) {
            _speak("Press the arrow to go back. Only press the pencil icon if the instructions specify");
          } else if (_counter == 38) {
            _speak("If the instructions in the card say you should press the pencil icon, please do so.");
          } else if (_counter == 1) {
            _speak("");
          }
        });
      } else {
        _timer.cancel();
      }
    });

    // Hide emojis after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showEmojis = false;
      });
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
   // _flutterTts.stop(); // Stop any ongoing speech
    super.dispose();
  }

  Future<void> _playPopSoundAndNavigate() async {
    try {
      // Play the audio file
      await _audioPlayer.play(AssetSource('audios/loud-pop-sound-effect.mp3'));
      int currentRound = database.getTeamRound(teamNo);
      if (currentRound % 1 == 0) {
        AdManager.showInterstitialAd();
      }

      // Navigate to the next page after playing the sound
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TeamSelectionPage(),
        ),
      );
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Text-to-Speech function
  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  // Update the dynamic text
  void _updateDynamicText() {
    setState(() {
      // Format the text based on the desired order, including the "answer"
      dynamicText = '''
        Instructions:
        No instructions available
        
        Task:
        No task available
        
        Price:
        No price available
        
        Answer:
        No answer available
        ''';
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.orange,
        body: SafeArea(
          child: Stack(
            children: [
              // Emoji splash
              if (showEmojis) Positioned.fill(child: _buildEmojiSplash(context)),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Top bar with "Kenya@50" and emoji
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'FunTime',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          AnimatedRotation(
                            turns: _counter % 2 == 0 ? 0.1 : -0.1,
                            duration: Duration(milliseconds: 500),
                            child: const Text(
                              '😜',
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // "SUPREME COURT" button
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _animation.value,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
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
                    // Middle card with dynamic instructions text
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      padding: EdgeInsets.all(20),
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        color: _animation.value,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          dynamicText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "SmoochaSans-VariableFont_wght.ttf",
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Black container with emoji and timer
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
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
                            child: const Text(
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _counter <= 40  ? _playPopSoundAndNavigate : null,
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: _counter <= 40 ? Colors.green : Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: _counter <= 30
                                          ? () async {
                                        await _audioPlayer.play(
                                            AssetSource('audios/loud-pop-sound-effect.mp3'));
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GenerateWordsPage(teamNo: teamNo), // Pass teamNo here
                                          ),
                                              (Route<dynamic> route) => false, // Removes all previous routes
                                        );

                                      }
                                          : null,
                                      child: Icon(
                                        Icons.edit,
                                        color: _counter <= 30 ? Colors.green : Colors.grey,
                                        size: 40,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '$_counter',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                    ),
                    const SizedBox(height: 40),
                    //Banner add container
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), // Adjust padding as needed
                      child: Container(
                        height: 50, // Adjust based on your ad size
                        width: double.infinity,
                        color: Colors.transparent, // Keep background transparent if needed
                        alignment: Alignment.center,
                        //child: AdManager.getBannerAd(), // Display the banner ad
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

  Widget _buildEmojiSplash(BuildContext context) {
    return Stack(
      children: List.generate(
        50,
            (index) {
          final random = Random();
          final left = random.nextDouble() * MediaQuery.of(context).size.width;
          final top = random.nextDouble() * MediaQuery.of(context).size.height;
          return Positioned(
            left: left,
            top: top,
            child: Text(
              ['😂', '😌', '🤪', '🥰', '😎'][random.nextInt(5)],
              style: TextStyle(fontSize: random.nextDouble() * 40 + 10),
            ),
          );
        },
      ),
    );
  }
}

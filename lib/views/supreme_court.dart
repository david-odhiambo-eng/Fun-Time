import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenyan_game/views/team_selection.dart';

import '../ads_manager.dart';
import '../database.dart';
import '../global.dart';

class SupremeCourtScreen extends StatefulWidget {
  final int teamNo;
  const SupremeCourtScreen({super.key, required this.teamNo});
  @override
  _BlackCardScreenState createState() => _BlackCardScreenState();
}

class _BlackCardScreenState extends State<SupremeCourtScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  int _counter = 50;
  late Timer _timer;
  late int teamNo;
  late FlutterTts _flutterTts;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<String> usedSupreme;
  late List<Map<String, dynamic>> supremeCards;
  late List<Map<String, dynamic>> words;

  // Placeholder dynamic text
  String dynamicText = "";

  // Emoji splash
  bool showEmojis = true;

  @override
  void initState() {
    super.initState();

    // Initialize FlutterTTS
    teamNo = widget.teamNo;
    _flutterTts = FlutterTts();
    supremeCards = Database().getCards(supreme: true);
    usedSupreme = usedSupremeCards;

    // Select a random item from the filtered list
    if (supremeCards.isNotEmpty) {
      Random random = Random();
      Map<String, dynamic> selectedItem =
      supremeCards[random.nextInt(supremeCards.length)];
      setState(() {
        words = List.from(selectedItem["words"]);
      });
      usedSupremeCards.add(selectedItem["card_id"]);
      setState(() {
        dynamicText = "${words[0]["word"]}\n${words[0]["results"]}";
      });
    } else {
      setState(() {
        dynamicText = "No Internet!!!";
      });
    }

    // Animation for "BLACK CARD"
    _controller = AnimationController(
      duration: const Duration(seconds: 50),
      vsync: this,
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.blue, end: Colors.grey[800])
        .animate(_controller);

    // Timer countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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


    // Emoji splash timer
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showEmojis = false; // Hide emojis after 3 seconds
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
    if (counter == 40) {
      _speak("You are free to exit this page");
    } else if (counter == 20) {
      _speak("You are free to exit this page");
    } else if (counter == 1) {
      _speak("You are free to exit this page");
    }
  }

  // Speak function using FlutterTTS
  Future<void> _speak(String message) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(message);
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
              if (showEmojis)
                Positioned.fill(
                  child: _buildEmojiSplash(),
                ),

              // Main content
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
                              '😜',
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                              'THE LAW',
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
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(20),
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
                      child: Center(
                        child: Text(
                          dynamicText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "SmoochSans-VariableFont_wght.ttf",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(8.0),
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
                            duration: const Duration(milliseconds: 500),
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
                                child: GestureDetector(
                                  onTap: _counter <= 40 ? _playPopSoundAndNavigate : null, // Enable navigation at 40s or below
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: _counter <= 40 ? Colors.green : Colors.grey, // Turns green at 40s or below
                                    size: 50,
                                  ),
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

  Widget _buildEmojiSplash() {
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

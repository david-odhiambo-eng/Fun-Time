import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

import 'package:kenyan_game/views/team_selection.dart';

import '../ads_manager.dart';
import '../database.dart';
import '../global.dart';

class SwitchRedScreen extends StatefulWidget {
  final int teamNo;
  const SwitchRedScreen({super.key, required this.teamNo});
  @override
  _BlackCardScreenState createState() => _BlackCardScreenState();
}

class _BlackCardScreenState extends State<SwitchRedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  int _counter = 40;
  late Timer _timer;
  late int teamNo;
  late FlutterTts _flutterTts;
  final AudioPlayer _audioPlayer = AudioPlayer();

  late List<String> usedRed;
  late List<Map<String, dynamic>> redCards;
  late List<String> words;

  // Placeholder dynamic text
  String dynamicText = "";

  // Emoji splash
  bool showEmojis = true;


  @override
  void initState() {
    super.initState();

    // Initialize FlutterTts
    teamNo  = widget.teamNo;
    _flutterTts = FlutterTts();
    redCards=Database().getCards(red: true);
    usedRed=usedRedCards;

    // Select a random item from the filtered list
    if (redCards.isNotEmpty) {
      Random random = Random();
      Map<String, dynamic> selectedItem = redCards[random.nextInt(redCards.length)];
      setState(() {
        words = List.from(selectedItem["words"]);
      });
      usedRedCards.add(selectedItem["card_id"]);
    } else {
      setState(() {
        words = List.generate(10, (index) => 'No Internet ${index + 1}');
      });
    }

    // Animation for "BLACK CARD"
    _controller = AnimationController(
      duration: Duration(seconds: 25),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(begin: Colors.red, end: Colors.grey[800])
        .animate(_controller);

    // Timer countdown with voice announcements
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });

        if (_counter == 48) {
          //_speak("If unfamiliar with most words, press S to switch to another card.");
        } else if (_counter == 20) {
          _speak("20 seconds remaining");
        } else if (_counter == 10) {
          _speak("10 seconds remaining");
        } else if (_counter == 1) {
          _speak("Time is up! Time is up! Stop");
        }
      } else {
        _timer.cancel();
      }
    });


    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showEmojis = false; // Hide emojis after 3 seconds
      });
    });

  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
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
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _flutterTts.stop();
    super.dispose();
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
                  child: _buildEmojiSplash(context),
                ),

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
                              'HARAMBEE CARD',
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(words.length, (index) {
                          return Text(
                            '${index + 1}. ${words[index]}',
                            style: const TextStyle(
                              fontFamily: "SmoochSans-VariableFont_wght.ttf",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
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
                            child: GestureDetector(
                              onTap: (_counter <= 50 && _counter >= 40)
                                  ? () {
                                // Add what should happen when "S" is tapped
                                print("S tapped!");
                              }
                                  : null, // Disable outside the time range
                              child: Text(
                                'S',
                                style: TextStyle(
                                  fontSize: 36, // Same size as the emoji
                                  fontWeight: FontWeight.bold,
                                  color: (_counter <= 50 && _counter >= 40) ? Colors.green : Colors.grey,
                                ),
                              ),
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
                                  onTap: _counter == 0
                                      ? _playPopSoundAndNavigate // Play sound and navigate
                                      : null, // Disable tap until counter is 0
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: _counter == 0 ? Colors.green : Colors.grey,
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


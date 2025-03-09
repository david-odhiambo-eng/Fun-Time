import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart'; // Importing the audioplayers package
import 'package:kenyan_game/ads_manager.dart';
import 'package:kenyan_game/views/switch_black.dart';
import 'package:kenyan_game/views/team_selection.dart';


import '../database.dart';
import '../global.dart';

class BlackCardScreen extends StatefulWidget {
  final int teamNo;
  const BlackCardScreen({super.key, required this.teamNo});

  @override
  _BlackCardScreenState createState() => _BlackCardScreenState();
}

class _BlackCardScreenState extends State<BlackCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  int _counter = 50;
  late int teamNo;
  late Timer _timer;
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
  late List<String> usedBlack;
  late List<Map<String, dynamic>> blackCards;
  late List<String> words;

  // Placeholder dynamic text
  String dynamicText = "";

  // Emoji splash
  bool showEmojis = true;


  @override
  void initState() {
    super.initState();
    teamNo = widget.teamNo;
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setPitch(1.0);

    blackCards = Database().getCards(black: true);
    usedBlack = usedBlackCards;

    // Select a random item from the filtered list
    if (blackCards.isNotEmpty) {
      Random random = Random();
      Map<String, dynamic> selectedItem =
      blackCards[random.nextInt(blackCards.length)];
      setState(() {
        words = List.from(selectedItem["words"]);
      });
      usedBlackCards.add(selectedItem["card_id"]);
    } else {
      setState(() {
        words = List.generate(10, (index) => 'No Internet ${index + 1}');
      });
    }

    _controller = AnimationController(
      duration: Duration(seconds: 25),
      vsync: this,
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.black, end: Colors.grey[800])
        .animate(_controller);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });

        if (_counter == 40) {
          _speak("If unfamiliar with most words, press S to switch to another card.");
        } else if (_counter == 30) {
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

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showEmojis = false; // Hide emojis after 3 seconds
      });
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

  Future<void> _playPopSoundAndNavigate() async {
    try {
      // Play the audio file
      await _audioPlayer.play(AssetSource('audios/loud-pop-sound-effect.mp3'));
      int currentRound = database.getTeamRound(teamNo);
      if (currentRound % 1 == 0) {
        AdManager.showInterstitialAd();
      }


      // Navigate to the next page after playing the sound
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>  TeamSelectionPage(),
        ),
            (Route<dynamic> route) => false, // Removes all previous routes
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
          child:Stack(
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
                            duration: const Duration(milliseconds: 500),
                            child: const Text(
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
                            child: const Text(
                              'SHUJAA CARD',
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(words.length, (index) {
                          return Text(
                            '${index + 1}. ${words[index]}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "SmoochSans-VariableFont_wght.ttf",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                            duration: const Duration(milliseconds: 500),
                            child: GestureDetector(
                              onTap: (_counter <= 50 && _counter >= 30)
                                  ? () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SwitchBlackScreen(teamNo: 1),
                                  ),
                                      (Route<dynamic> route) => false, // Removes all previous routes
                                );


                              }
                                  : null, // Disable outside the time range
                              child: Text(
                                'S',
                                style: TextStyle(
                                  fontSize: 36, // Same size as the emoji
                                  fontWeight: FontWeight.bold,
                                  color: (_counter <= 50 && _counter >= 30) ? Colors.green : Colors.grey,
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
                        child: AdManager.getBannerAd(), // Display the banner ad
                      ),
                    ),
                  ],
                ),
              ),

            ],
          )
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



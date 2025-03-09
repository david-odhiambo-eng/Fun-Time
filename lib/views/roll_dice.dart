import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package
import 'package:kenyan_game/database.dart';
import 'package:kenyan_game/views/red_card.dart';
import 'package:kenyan_game/views/supreme_court.dart';
import 'package:kenyan_game/views/black_card.dart';
import 'package:kenyan_game/views/gamble_card.dart';

import '../global.dart';
import 'generate_words.dart';

class RollDicePage extends StatefulWidget {
  final int teamNumber;

  // Constructor to accept the team number
  const RollDicePage({required this.teamNumber});
  @override
  _RollDicePageState createState() => _RollDicePageState();
}

class _RollDicePageState extends State<RollDicePage> with TickerProviderStateMixin {
  late int currentRound; // Current round (0 to totalRounds)
  final int totalRounds = 12;
  late int teamNumber;
  int diceNumber = 1;
  late AnimationController _emojiController;
  late AnimationController _diceController;
  late AnimationController _buttonController;
  late Animation<Offset> _buttonAnimation;
  late FlutterTts flutterTts;
  late AudioPlayer _audioPlayer; // AudioPlayer instance for ticking sound
  bool isPlayingTickSound = false; // Track ticking sound state
  bool buttonsVisible = false;
  bool buttonPressed = false;
  int countdown = 10;
  bool canRoll = true; // Prevents multiple rolls
  bool isRotating = false;

  // Define card choices for each round (keys are 0 to 12)
  // Added key 0 to avoid null check errors when round resets.
  final Map<int, List<String>> roundChoices = {
    0: ['Shujaa', 'Harambee', 'The Law', 'Gamble', 'Generate'], // Add "Generate" here
    1: ['Shujaa', 'Harambee', 'The Law', 'Gamble', 'Generate'],
    2: ['Shujaa', 'Harambee'],
    3: ['The Law', 'Generate'], // Add "Generate" in other rounds as needed
    4: ['Shujaa', 'Gamble'],
    5: ['Harambee', 'The Law', 'Gamble'],
    6: ['Shujaa'],
    7: ['Harambee', 'Gamble', 'Generate'],
    8: ['Harambee'],
    9: ['Shujaa', 'The Law', 'Gamble'],
    10: ['Gamble'],
    11: ['Shujaa', 'Harambee'],
    12: ['Shujaa', 'Harambee', 'The Law', 'Gamble', 'Generate'],
  };

  @override
  void initState() {
    super.initState();

    // Initialize Text to Speech and Audio
    teamNumber = widget.teamNumber;
    // Initialize currentRound from the database (default to 0 if not set)
    currentRound = Database().getTeamRound(teamNumber) ?? 0;

    flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer(); // Initialize AudioPlayer

    // Emoji animation controller
    _emojiController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Dice animation controller
    _diceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Button slide animation controller
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emojiController.dispose();
    _diceController.dispose();
    _buttonController.dispose();
    _audioPlayer.stop(); // Stop ticking sound
    _audioPlayer.dispose(); // Dispose AudioPlayer
    flutterTts.stop();
    super.dispose();
  }

  void rollDice() {
    if (!canRoll) return; // Prevent multiple rolls within 10 seconds
    canRoll = false; // Disable rolling until the countdown ends

    setState(() {
      diceNumber = Random().nextInt(6) + 1;
      // Increment round: if current round is the 12th, reset to 0; otherwise, increase by 1.
      if (currentRound == totalRounds) {
        currentRound = 0;
      } else {
        currentRound = currentRound + 1;
      }

      Database().updateTeamRound(teamNumber, currentRound);
      // Optionally, re-read from the database if needed.
      currentRound = Database().getTeamRound(teamNumber) ?? currentRound;
      buttonsVisible = true;
      countdown = 10;
      buttonPressed = false;
    });

    // Trigger animations
    _diceController.forward(from: 0.0);
    _emojiController.forward(from: 0.0);

    // Play voice command
    flutterTts.speak("Select A Card");

    // Start countdown
    startCountdown();

    // Start button animation
    _buttonController.forward(from: 0.0);
  }

  void startCountdown() {
    if (!isPlayingTickSound) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _audioPlayer.play(AssetSource('audios/beep.wav'));
      isPlayingTickSound = true;
    }

    Future.delayed(Duration(seconds: 1), () {
      if (countdown > 0 && !buttonPressed) {
        setState(() {
          countdown--;
        });
        startCountdown();
      } else {
        _audioPlayer.stop();
        isPlayingTickSound = false;

        if (!buttonPressed) {
          navigateToRandomPage(teamNumber);
        }

        canRoll = true; // Re-enable rolling after countdown ends
      }
    });
  }


  void navigateToRandomPage(int teamNo) {
    final choices = roundChoices[currentRound]!;
    final randomChoice = choices[Random().nextInt(choices.length)];

    switch (randomChoice) {
      case 'Shujaa':
        Navigator.push(context, MaterialPageRoute(builder: (context) => BlackCardScreen(teamNo: teamNo))); // Replace with the correct screen
        break;
      case 'Harambee':
        Navigator.push(context, MaterialPageRoute(builder: (context) => RdCardScreen(teamNo: teamNo))); // Replace with the correct screen
        break;
      case 'The Law':
        Navigator.push(context, MaterialPageRoute(builder: (context) => SupremeCourtScreen(teamNo: teamNo)));
        break;
      case 'Gamble':
        Navigator.push(context, MaterialPageRoute(builder: (context) => GambleCardScreen(teamNo: teamNo)));
        break;
      case 'Generate':
        Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateWordsPage(teamNo: teamNo)));
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.orange,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top row: Round display and refresh icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Round $currentRound/$totalRounds',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 350 ? 18 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Prevent refresh if a dice roll/selection is in progress
                          if (buttonsVisible) return;
                          if (!isRotating && (countdown == 10 || countdown < 1)) {
                            setState(() {
                              // Reset to round 0 so that the round indicator shows 0/12.
                              currentRound = 0;
                              Database().updateTeamRound(teamNumber, currentRound);
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: (isRotating || countdown > 0) ? Colors.red.shade700 : Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            Icons.refresh,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  // Dice Icon with decorative container
                  GestureDetector(
                    onTap: rollDice,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(4, 4),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(_diceController),
                        child: const Icon(
                          Icons.casino, // Dice-like icon
                          size: 150,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Instruction text
                  const Text(
                    "Touch to Roll Dice",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Countdown and Buttons (only visible after dice roll)
                  if (buttonsVisible) ...[
                    Text(
                      'Choose: $countdown',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Animated Buttons based on roundChoices
                    SlideTransition(
                      position: _buttonAnimation,
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        alignment: WrapAlignment.center,
                        children: roundChoices[currentRound]!.map((card) {
                          Color btnColor;
                          switch (card) {
                            case 'Shujaa':
                              btnColor = Colors.black;
                              break;
                            case 'Harambee':
                              btnColor = Colors.red;
                              break;
                            case 'The Law':
                              btnColor = Colors.white;
                              break;
                            case 'Gamble':
                              btnColor = Colors.green;
                              break;
                            case 'Generate':  // New color for "Generate"
                              btnColor = Colors.blue;
                              break;
                            default:
                              btnColor = Colors.grey;
                          }

                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                buttonPressed = true;
                              });
                              _audioPlayer.stop(); // Stop ticking sound

                              switch (card) {
                                case 'Shujaa':
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlackCardScreen(teamNo: teamNumber)));
                                  break;
                                case 'The Law':
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SupremeCourtScreen(teamNo: teamNumber)));
                                  break;
                                case 'Harambee':
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RdCardScreen(teamNo: teamNumber)));
                                  break;
                                case 'Gamble':
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GambleCardScreen(teamNo: teamNumber)));
                                  break;
                                case 'Generate':  // ✅ Added "Generate" case
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GenerateWordsPage(teamNo: teamNumber)));
                                  break;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: btnColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: Text(
                              card,
                              style: TextStyle(
                                color: card == 'The Law' ? Colors.black : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );

                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

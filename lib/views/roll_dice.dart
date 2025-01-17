import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kenyan_game/views/red_card.dart';
import 'package:kenyan_game/views/supreme_court.dart';
import 'package:kenyan_game/views/black_card.dart';
import 'package:kenyan_game/views/gamble_card.dart';

class RollDicePage extends StatefulWidget {
  @override
  _RollDicePageState createState() => _RollDicePageState();
}

class _RollDicePageState extends State<RollDicePage> with TickerProviderStateMixin {
  int currentRound = 0; // Start with round 1
  final int totalRounds = 12;
  int diceNumber = 1;
  late AnimationController _emojiController;
  late Animation<double> _emojiAnimation;
  late AnimationController _diceController;
  late AnimationController _buttonController;
  late Animation<Offset> _buttonAnimation;
  late FlutterTts flutterTts;
  bool buttonsVisible = false;
  bool buttonPressed = false;
  int countdown = 10;

  // Define card choices for each round
  final Map<int, List<String>> roundChoices = {
    1: ['Black', 'Red', 'Supreme Court', 'Gamble'],
    2: ['Black', 'Red'],
    3: ['Supreme Court'],
    4: ['Black', 'Gamble'],
    5: ['Red', 'Supreme Court', 'Gamble'],
    6: ['Black'],
    7: ['Red', 'Gamble'],
    8: ['Red'],
    9: ['Black', 'Supreme Court', 'Gamble'],
    10: ['Gamble'],
    11: ['Black', 'Red'],
    12: ['Black', 'Red', 'Supreme Court', 'Gamble'],
  };

  @override
  void initState() {
    super.initState();

    // Initialize Text to Speech
    flutterTts = FlutterTts();

    // Emoji animation controller
    _emojiController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _emojiAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _emojiController, curve: Curves.linear),
    );

    // Dice animation controller
    _diceController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // Button slide animation controller
    _buttonController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emojiController.dispose();
    _diceController.dispose();
    _buttonController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void rollDice() {
    setState(() {
      diceNumber = Random().nextInt(6) + 1;
      currentRound = (currentRound % totalRounds) + 1; // Move to next round
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
    Future.delayed(Duration(seconds: 1), () {
      if (countdown > 0 && !buttonPressed) {
        setState(() {
          countdown--;
        });
        startCountdown();
      } else if (!buttonPressed) {
        // Navigate to a random page when the countdown reaches 0
        navigateToRandomPage();
      }
    });
  }

  void navigateToRandomPage() {
    final choices = roundChoices[currentRound]!;
    final randomChoice = choices[Random().nextInt(choices.length)];

    switch (randomChoice) {
      case 'Black':
        Navigator.push(context, MaterialPageRoute(builder: (context) => BlackCardScreen()));
        break;
      case 'Supreme Court':
        Navigator.push(context, MaterialPageRoute(builder: (context) => SupremeCourtScreen()));
        break;
      case 'Red':
        Navigator.push(context, MaterialPageRoute(builder: (context) => RdCardScreen()));
        break;
      case 'Gamble':
        Navigator.push(context, MaterialPageRoute(builder: (context) => GambleCardScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Round display
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Round $currentRound/$totalRounds',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    RotationTransition(
                      turns: _emojiAnimation,
                      child: Text(
                        "😜",
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ],
                ),
              ),

              // Dice Icon
              GestureDetector(
                onTap: rollDice,
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_diceController),
                  child: Icon(
                    Icons.casino, // Dice-like icon
                    size: 150,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 60),

              // Instruction text
              Text(
                "Touch to Roll Dice",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 40),

              // Countdown and Buttons
              if (buttonsVisible) ...[
                Text(
                  'Time Left: $countdown',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),

                // Animated Buttons based on roundChoices
                SlideTransition(
                  position: _buttonAnimation,
                  child: Wrap(
                    spacing: 10.0,
                    children: roundChoices[currentRound]!.map((card) {
                      return ElevatedButton(
                        onPressed: () {
                          buttonPressed = true;
                          switch (card) {
                            case 'Black':
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BlackCardScreen()));
                              break;
                            case 'Supreme Court':
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SupremeCourtScreen()));
                              break;
                            case 'Red':
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RdCardScreen()));
                              break;
                            case 'Gamble':
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GambleCardScreen()));
                              break;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: card == 'Black'
                              ? Colors.black
                              : card == 'Red'
                              ? Colors.red
                              : card == 'Supreme Court'
                              ? Colors.white
                              : Colors.green,
                        ),
                        child: Text(card),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

}

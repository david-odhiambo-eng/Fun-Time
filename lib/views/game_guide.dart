import 'package:flutter/material.dart';
import 'package:kenyan_game/views/rules_page.dart';

class GameGuide extends StatelessWidget {
  const GameGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text(
          'Game Guide',
          style: TextStyle(
            fontFamily: "SmoochSans-VariableFont_wght.ttf",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'FunTime, a game of words',
                  style: TextStyle(
                    fontFamily: "SmoochSans-VariableFont_wght.ttf",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "1. Split into teams.\n\n"
                      "2. Each team selects one member as the word describer.\n\n"
                      "3. The describer sees a word on a card (e.g., 'Jomo Kenyatta') and explains it using different words without saying the actual word. The team must guess what it is.\n\n"
                      "4. For example, instead of saying 'Jomo Kenyatta', the describer could ask, 'Who was the first president of Kenya?'\n\n"
                      "5. If the team correctly guesses 'Jomo Kenyatta', they earn points.\n\n"
                      "6. Each correct answer earns your team 10 points.\n\n"
                      "7. Practice round: Try describing 'Ugali' without using the word itself.\n\n"
                      "8. If you successfully described 'Ugali' using other words, you're ready to start the game!",
                  style: TextStyle(
                    fontFamily: "SmoochSans-VariableFont_wght.ttf",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.green,
                    size: 80,
                  ),
                  onPressed: () {
                    _playPopSoundAndNavigate(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _playPopSoundAndNavigate(BuildContext context) {
    // TODO: Add sound effect logic if needed
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RulesPage()),
    );
  }
}

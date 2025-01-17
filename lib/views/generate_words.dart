import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GenerateWordsPage extends StatefulWidget {
  const GenerateWordsPage({Key? key}) : super(key: key);

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

      if (_counter == 30) {
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
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Kenya@50",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: _startTimer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
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
                const SizedBox(width: 16),
                AnimatedOpacity(
                  opacity: _isTimerRunning ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Generate words for each of the following topics",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              hintText: _hints[index],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

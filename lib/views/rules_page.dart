import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For playing sound effects
import 'package:kenyan_game/views/rules_one.dart'; // Import your next page

class RulesPage extends StatefulWidget {
  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Define a scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPopSoundAndNavigate() async {
    // Play a pop sound
    await SystemSound.play(SystemSoundType.click);

    // Navigate to the next page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RulesPageOne()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top:40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Title
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'RULE 1',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 40,),

                // Description with black background and animation
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'There are 4 options of playing the game. You can:\n'
                              '1. "Start Game With My Team"\n'
                              '2. "Resume Game With My Team"\n'
                              '3. "Join Via Code"\n'
                              '4. "Join To Record Points"',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
                SizedBox(height: 40,),

                // Emojis and Bottle
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text("😜", style: TextStyle(fontSize: 40)),
                        ),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text("😎", style: TextStyle(fontSize: 40)),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.smartphone, size: 120, color: Colors.black),
                        Transform.rotate(
                          angle: 0.2,
                          child: Icon(
                            Icons.local_drink,
                            size: 60,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text("😍", style: TextStyle(fontSize: 40)),
                        ),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text("😜", style: TextStyle(fontSize: 40)),
                        ),
                      ],
                    ),
                  ],
                ),

                // Play Button
                ElevatedButton(
                  onPressed: _playPopSoundAndNavigate,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.green,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

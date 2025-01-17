import 'package:flutter/material.dart';
import 'package:kenyan_game/views/roll_dice.dart';

import 'landing_page.dart';

class TeamSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Select Your Team',
          style: TextStyle(
            fontFamily: "Pacifico",
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(),
            SizedBox(height: 100),
            _buildAnimatedTeamButton(context, 'Team One', Colors.red),
            _buildAnimatedTeamButton(context, 'Team Two', Colors.blue),
            _buildAnimatedTeamButton(context, 'Team Three', Colors.green),
            _buildAnimatedTeamButton(context, 'Team Four', Colors.purple),
            _buildAnimatedTeamButton(context, 'Team Five', Colors.yellow),
            SizedBox(height: 50),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: IconButton(
                      icon: Icon(Icons.play_circle),
                      color: Colors.green,
                      iconSize: 80,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LandingPage()),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTeamButton(BuildContext context, String teamName, Color color) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, -50 * (1 - value)),
            child: _buildTeamButton(context, teamName, color),
          ),
        );
      },
    );
  }

  Widget _buildTeamButton(BuildContext context, String teamName, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RollDicePage()),
          );
        },
        child: Text(
          teamName,
          style: const TextStyle(
            fontFamily: "Pacifico",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

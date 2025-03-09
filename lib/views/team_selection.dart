import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the AudioPlayers package
import 'package:kenyan_game/ads_manager.dart';
import 'package:kenyan_game/global.dart';
import 'package:kenyan_game/views/roll_dice.dart';
import '../progress.dart';
import 'landing_page.dart';

class TeamSelectionPage extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  TeamSelectionPage({super.key}); // Initialize the AudioPlayer

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100), // Adjust space from top
              Center(child: _buildAnimatedTeamButton(context, 'Team One',1, Colors.red)),
              Center(child: _buildAnimatedTeamButton(context, 'Team Two',2, Colors.blue)),
              Center(child: _buildAnimatedTeamButton(context, 'Team Three',3, Colors.green)),
              Center(child: _buildAnimatedTeamButton(context, 'Team Four',4, Colors.purple)),
              Center(child: _buildAnimatedTeamButton(context, 'Team Five',5, Colors.yellow)),
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
                          _playPopSoundAndNavigate(context); // Call the new method here
                        },
                      ),
                    ),
                  );
                },
              ),
              // SizedBox(height: 40),
              // //Banner add container
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0), // Adjust padding as needed
              //   child: Container(
              //     height: 50, // Adjust based on your ad size
              //     width: double.infinity,
              //     color: Colors.transparent, // Keep background transparent if needed
              //     alignment: Alignment.center,
              //     child: AdManager.getBannerAd(), // Display the banner ad
              //   ),
              // ),
            ],
          ),

        ),
      ),
    );
  }

  // Method to play pop sound and navigate
  Future<void> _playPopSoundAndNavigate(BuildContext context) async {
    try {
      // Play the audio file
      await _audioPlayer.play(AssetSource('audios/loud-pop-sound-effect.mp3'));

      AdManager.showInterstitialAd();
      // Navigate to the next page after playing the sound

      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => LandingPage(),
        ),
      );
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Widget _buildAnimatedTeamButton(BuildContext context, String teamName,int no, Color color) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, -50 * (1 - value)),
            child: _buildTeamButton(context, teamName,no, color),
          ),
        );
      },
    );
  }

  Widget _buildTeamButton(BuildContext context, String teamName,int no, Color color) {
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
          if(database.getTeamRound(no) <= 12){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RollDicePage(teamNumber: no,), // Navigate directly to the RollDicePage
              ),
            );
          }else{
            Dialogs().showSnackBar("12 rounds played");
          }

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

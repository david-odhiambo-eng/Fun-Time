import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kenyan_game/ads_manager.dart';
import 'landing_page.dart'; // Import LandingPage

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  bool _isBlurred = true; // Initially blurred

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 300), (Timer timer) {
      setState(() {
        _isBlurred = true; // Blur the screen every 5 minutes
      });
    });
  }

  void _unblurScreen() {
    setState(() {
      _isBlurred = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.orange,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 35.0, left: 16.0, right: 16.0),
                  child: Text(
                    "FunTime",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      Card(
                        elevation: 10,
                        shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: screenHeight * 0.7,
                          width: screenWidth * 0.9,
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              _isBlurred ? 'Press "See Screen"' : 'Game Content Goes Here',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      if (_isBlurred)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        AdManager.showInterstitialAd();
                        _unblurScreen();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'See Screen',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LandingPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all( 8.0), // Prevents clipping
            child: SizedBox(
              height: 50, // Ensure a fixed height
              width: double.infinity,
              child: AdManager.getBannerAd(), // Display the banner ad properly
            ),
          ),
        ),
      ),
    );
  }

}


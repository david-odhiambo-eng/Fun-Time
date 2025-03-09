import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:kenyan_game/views/payment_page.dart';
import 'landing_page.dart';

class AnonymousPage extends StatelessWidget {
  const AnonymousPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colors.orange, // Retained background color
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated Circular Avatar at the top
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/funtime.png'),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // "WELCOME TO KENYA@50" text
              BounceInDown(
                duration: const Duration(milliseconds: 1200),
                child: const Text(
                  "WELCOME TO\nFunTime",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // "Play Free With Ads" button
              SlideInUp(
                duration: const Duration(milliseconds: 1400),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LandingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Play Free With Ads',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // "Pay 24/=. No Ads for 24hrs" button with hint
              PaymentButtonWithHint(),
            ],
          ),
        ),
      ),
    );
  }
}

// Stateful Widget to handle blinking hint text
class PaymentButtonWithHint extends StatefulWidget {
  @override
  _PaymentButtonWithHintState createState() => _PaymentButtonWithHintState();
}

class _PaymentButtonWithHintState extends State<PaymentButtonWithHint> {
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _startHintToggle();
  }

  void _startHintToggle() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _showHint = !_showHint;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideInUp(
          duration: const Duration(milliseconds: 1400),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 10,
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Pay 24/=. No Ads for 24hrs',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 5), // Space between button and hint text
        if (_showHint)
          FadeIn(
            duration: const Duration(milliseconds: 500),
            child: const Text(
              'If already paid, click to confirm',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

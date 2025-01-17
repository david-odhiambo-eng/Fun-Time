import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
import 'package:kenyan_game/views/landing_page.dart';
import 'package:kenyan_game/views/roll_dice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Lock orientation to portrait mode
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, // Only allow portrait orientation
  // ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meme App",
      theme: ThemeData(
        fontFamily: "Pacifico",
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kenyan_game/ads_manager.dart';
import 'package:kenyan_game/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kenyan_game/views/wlecome_page.dart';
import 'firebase_options.dart';
import 'database.dart';
import 'package:in_app_update/in_app_update.dart'; // Import in-app update package


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Only allow portrait mode
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Database().initCards();
  // Initialize Google Mobile Ads
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize Firebase Analytics
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    checkForUpdates(); // Check for updates on app start

    // Log app open event
    analytics.logAppOpen();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AdManager.initialiseAds();
      }
    });
  }

  void checkForUpdates() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Immediate update (forces the update)
          InAppUpdate.performImmediateUpdate().catchError((e) {
            debugPrint("Error during immediate update: $e");
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Flexible update (lets user continue using app)
          InAppUpdate.startFlexibleUpdate().then((_) {
            debugPrint("Flexible update started");
          }).catchError((e) {
            debugPrint("Error during flexible update: $e");
          });
        }
      } else {
        debugPrint("No updates available");
      }
    } catch (e) {
      debugPrint("Error checking for updates: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meme App",
      navigatorKey: navigatorKey,
      theme: ThemeData(
        fontFamily: "SmoochSans-VariableFont_wght.ttf",
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics), // Add analytics observer
      ],
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

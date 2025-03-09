import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kenyan_game/subscription.dart';
import 'dart:io';

import 'global.dart';

class AdManager {
  static InterstitialAd? _interstitialAd;
  static BannerAd? _bannerAd;
  static bool _bannerLoaded = false;
  static const String _interstitialUnit = "ca-app-pub-2313717454304156/5887933722";
  static const String _interstitialTestUnit = 'ca-app-pub-3940256099942544/1033173712';
  static const String _iphoneInterstitialUnit = 'ca-app-pub-3940256099942544/4411468910';
  static const String _bannerAdUnit = "ca-app-pub-2313717454304156/6118738718";
  static const String _bannerTestUnit = "ca-app-pub-3940256099942544/9214589741";
  static const String _iphoneBannerUnit = "ca-app-pub-3940256099942544/2435281174";

  static Future<void> initialiseAds() async{
    _loadInterstitialAd();
    _loadBannerAd();
  }
  /// Load a new interstitial ad
  static void _loadInterstitialAd() {
    try{
      InterstitialAd.load(
        adUnitId: Platform.isAndroid ? debug ? _interstitialTestUnit: _interstitialUnit: _iphoneInterstitialUnit,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose(); // Dispose the old ad
                _loadInterstitialAd(); // Load a new ad
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose(); // Dispose the ad
                debugPrint("Failed to load interstitial ads $error");
                Future.delayed(const Duration(seconds: 10), _loadInterstitialAd);
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null; // Handle ad load failure
          },
        ),
      );
    }catch(e){
      debugPrint("Error loading int ad: $e");
    }

  }

  /// Show the interstitial ad
  static Future<void> showInterstitialAd() async {
    if(!(await _checkSubscriptionStatus())){
      return;
    }
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Clear the reference to prevent reuse
    } else {
      debugPrint("Didn't load interstitial ads");
    }
  }
  static void _loadBannerAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    try{
      if (navigatorKey.currentContext == null) {
        debugPrint("Error: navigatorKey.currentContext is null.");
        return;
      }
      final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.sizeOf(navigatorKey.currentContext!).width.truncate());

      if (size == null) {
        // Handle the case where the size could not be determined
        debugPrint('Failed to get adaptive banner size');
        return;
      }
      _bannerLoaded = false;
      _bannerAd = BannerAd(
        adUnitId: Platform.isAndroid ? debug ? _bannerTestUnit: _bannerAdUnit: _iphoneBannerUnit,
        request: const AdRequest(),
        size: size,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _bannerLoaded = true;
            debugPrint('$ad loaded.');
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            ad.dispose();
            // Wait before retrying to avoid excessive ad requests
            Future.delayed(const Duration(seconds: 10), _loadBannerAd);
          },
        ),
      )..load();
    }catch(e){
      debugPrint("Error getting banner: $e");
    }

  }

  static Widget getBannerAd() {
    return FutureBuilder<bool>(
      future: _checkSubscriptionStatus(), // Calls the async function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //CircularProgressIndicator(),
                SizedBox(width: 15),
                Text("")
              ],
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null || snapshot.data == true) {
          // Subscription expired or error => show ads
          if (_bannerAd != null && _bannerLoaded) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            );
          }
          // If ad is not loaded yet, show waiting UI
          return const Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //CircularProgressIndicator(),
                SizedBox(width: 15),
                Text("")
              ],
            ),
          );
        }

        // Subscription is active, hide ads
        return const SizedBox.shrink();
      },
    );
  }

  /// Async function to check if subscription has expired
  static Future<bool> _checkSubscriptionStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await SubscriptionService().isSubscriptionExpired(user);
    }
    return true; // Assume no subscription if user is null
  }
}
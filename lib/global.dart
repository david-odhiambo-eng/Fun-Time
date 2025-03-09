import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:kenyan_game/share_screen_module.dart';
import 'database.dart';
//call back for async process
typedef CallBackAction = void Function(bool isSuccess, String message);
//call for data processing processes
typedef DataCallBackAction = void Function(bool isSuccess, dynamic data);
//global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//global database instance
Database database = Database();
//set debug to true to run tests
const debug = false;
//base test url for the app
const baseTestUrl = 'http://192.168.0.100/main/';
//base app url
const baseUrl = 'https://kenyaatfifty-b4bf5259c052.herokuapp.com/main/';
//initiate stk push url
const stkPushUrl = "${(debug ? baseTestUrl : baseUrl)}payments/subscribe";
//confirm subscription
const confirmSubUrl = "${(debug ? baseTestUrl : baseUrl)}subscription/confirm";
//package
const packageName = "com.davy.kenya@50";
// webrtc signaling reference
final DatabaseReference signalingRef = FirebaseDatabase.instance.ref("webrtc_signaling");
// generate random character string
String generateRandomString(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final Random random = Random();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
}
//webrtc class
Webrtc webrtc = Webrtc(roomId: "1234567890");
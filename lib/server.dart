
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:kenyan_game/global.dart';
import 'package:http/http.dart' as http;

class Subscription{
  Future<void> subscribe(String phoneNumber, CallBackAction callback) async{
    if(!isValid(phoneNumber, callback)){
      return;
    }
    String url = stkPushUrl;
    // Define request body
    final Map<String, dynamic> requestBody = {
      "phone_number": phoneNumber,
      "period": 1, // Number of days for subscription default is 1
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Client": packageName
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        callback(true, "Enter pin when prompted.");
        debugPrint("STK Push Sent Successfully: $data");
      } else {
        final data = jsonDecode(response.body);
        callback(false, "${data['error']}");
        debugPrint("Error: ${data['error']}");
      }
    } catch (e) {
      debugPrint("Request failed: $e");
      callback(false,"Request failed: $e");
    }
  }
  Future<void> confirmSubscription(String phoneNumber, DataCallBackAction callback) async{
    if(!isValid(phoneNumber, callback)){
      return;
    }
    String url = "$confirmSubUrl?phone_number=$phoneNumber";
    try {
      final response = await http.get(
          Uri.parse(url),
          headers: {
            "Client": packageName
          });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Subscription Info: ${data['message']}");
        final subInfo = data["subscription_info"];
        callback(true, subInfo);
      } else {
        final data = jsonDecode(response.body);
        debugPrint("Error: ${data['message']}");
        callback(false, data["message"]);
      }
    } catch (e) {
      debugPrint("Request failed: $e");
      callback(false, "Request failed: $e");
    }
  }

  bool isValid(String phoneNumber, CallBackAction callback){
    if(phoneNumber.isEmpty){
      callback(false, "Invalid phone number provided!");
      return false;
    }
    // Ensure phone number contains only digits
    if (!RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      callback(false, "Enter a valid phone number (digits only)!");
      return false;
    }
    if(phoneNumber.length > 15){
      callback(false, "Phone number too long!");
      return false;
    }
    return true;
  }
}
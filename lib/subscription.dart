import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kenyan_game/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  Future<void> saveSubscriptionData(User user, String subStatus, String subValidTill) async {
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Store under userID key
      await prefs.setString('${user.uid}_sub_status', subStatus);
      await prefs.setString('${user.uid}_sub_valid_till', subValidTill);
      if(subStatus == "active"){
        Dialogs().showSnackBar("Ads have been disabled.");
      }
    }catch(e){
      debugPrint("Error: $e");
    }

  }

  Future<Map<String, String?>> _getSubscriptionData(User user) async {
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? subStatus = prefs.getString('${user.uid}_sub_status');
      String? subValidTill = prefs.getString('${user.uid}_sub_valid_till');

      return {
        "sub_status": subStatus,
        "sub_valid_till": subValidTill,
      };
    }catch (e){
      debugPrint("Error: $e");
      return {
        "sub_status": null,
        "sub_valid_till": null,
      };
    }

  }

  Future<void> removeSubscriptionData(User user) async {
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('${user.uid}_sub_status');
      await prefs.remove('${user.uid}_sub_valid_till');
    }catch(e){
      debugPrint("Error: $e");
    }

  }

  Future<bool> isSubscriptionExpired(User user) async {
    Map<String, String?> subInfo = await _getSubscriptionData(user);
    String? storedTimestamp = subInfo["sub_valid_till"];
    String? subStatus = subInfo["sub_status"];
    if(subStatus != null && storedTimestamp != null){
      DateTime storedDateTime = DateTime.parse(storedTimestamp);
      DateTime now = DateTime.now().toUtc();
      return now.isAfter(storedDateTime) || subStatus ==  "expired";
    }else{
      return true;
    }
  }

}

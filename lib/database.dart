import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:kenyan_game/global.dart';

List<String> usedBlackCards = [];
List<String> usedRedCards = [];
List<String> usedSupremeCards = [];
List<String> usedGambleCards = [];
List<Map<String, dynamic>> _listRedCards = [];
List<Map<String, dynamic>> _listBlackCards = [];
List<Map<String, dynamic>> _listSupremeCards = [];
List<Map<String, dynamic>> _listGambleCards = [];
String _blackCardJson = "";
String _redCardJson = "";
String _supremeCourtJson = "";
String _gambleCardJson = "";
int _team1Round =0;
int _team2Round =0;
int _team3Round =0;
int _team4Round =0;
int _team5Round =0;


class Database{
  int getTeamRound(int no){
    if(no == 1){
      return _team1Round;
    }else if(no == 2){
      return _team2Round;
    }
    else if(no == 3){
      return _team3Round;
    }
    else if(no == 4){
      return _team4Round;
    }else if(no == 5){
      return _team5Round;
    }else{
      return 0;
    }
  }
  void updateTeamRound(int no, int value){
    if(no == 1){
      _team1Round = value;
    }else if(no == 2){
      _team2Round = value;
    }
    else if(no == 3){
      _team3Round = value;
    }
    else if(no == 4){
      _team4Round = value;
    }else if(no == 5){
      _team5Round = value;
    }else{
      return;
    }
  }
  Future<void> initCards() async{
    try{
      final storageRef = FirebaseStorage.instance.ref().child('cards');

      // Download the JSON files as a string
      _supremeCourtJson = await storageRef.child("supreme_court.json").getData().then((value) => utf8.decode(value!));
      _redCardJson = await storageRef.child("red_card.json").getData().then((value) => utf8.decode(value!));
      _blackCardJson = await storageRef.child("black_card.json").getData().then((value) => utf8.decode(value!));
      _gambleCardJson = await storageRef.child("gamble_cards_updated.json").getData().then((value) => utf8.decode(value!));

      _listBlackCards = setCard(_blackCardJson);
      _listRedCards = setCard(_redCardJson);
      _listSupremeCards = setCard(_supremeCourtJson);
      _listGambleCards = setCard(_gambleCardJson);
    }catch(e){
      debugPrint("Error occurred: $e");
    }
  }
  List<Map<String, dynamic>> setCard(String jsonString){
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData['cards']);
  }
  List<Map<String, dynamic>> getCards({bool black =false,red=false,supreme=false, gamble =false}){
    if(black){
      return _listBlackCards.where((card) => !usedBlackCards.contains(card["card_id"])).toList();
    }else if(red){
      return _listRedCards.where((card) => !usedRedCards.contains(card["card_id"])).toList();
    }else if(supreme){
      return _listSupremeCards.where((card) => !usedSupremeCards.contains(card["card_id"])).toList();
    }
    else if(gamble){
      return _listGambleCards.where((card) => !usedGambleCards.contains(card["card_id"])).toList();
    }
    return [];
  }

  Future<void> uploadUserData(Map<String, dynamic> update, CallBackAction callback) async{
    try{
      DatabaseReference userRef = FirebaseDatabase.instance.ref("Users");
      await userRef.child(update["userId"]).set(update);
      callback(true, "Success");
    }catch(e){
      callback(false,"Error ${e.toString()}");
    }
  }
}
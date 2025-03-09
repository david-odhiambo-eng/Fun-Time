import 'package:flutter/material.dart';
import 'global.dart';

class Dialogs{
  showLoadingDialog(String message){
    showDialog(context: navigatorKey.currentContext!,
        builder: (BuildContext context){
          return Dialog(
            child: Padding(padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //const CircularProgressIndicator(),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(message)
                ],
              ),),
          );
        });
  }
  showSnackBar(String message){
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );

  }
}
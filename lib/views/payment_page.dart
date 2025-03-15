import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenyan_game/global.dart';
import 'package:kenyan_game/progress.dart';
import 'package:kenyan_game/server.dart';
import 'package:kenyan_game/subscription.dart';

import 'already_paid.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _phoneController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController.text = '254 ';
  }
  Future<void> _sendSTKPush(String phoneNumber) async{
    Dialogs().showLoadingDialog("Please wait");
    await Subscription().subscribe(phoneNumber, callback);
  }

  void callback(bool isSuccess, String message){
    Navigator.of(navigatorKey.currentContext!).pop();
    if(isSuccess){
      //proceed to verify payments success
      //remove current subscription data
      Dialogs().showSnackBar(message);
      if(user != null){
        SubscriptionService().removeSubscriptionData(user!);
      }
      Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>AlreadyPaid()));
    }else{
      //Something went wrong, try again
      Dialogs().showSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pay Ksh.24. Disable ads for 24hrs',
          style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf"),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400, // Prevents stretching too wide on large screens
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 13, // Ensures correct length
                      decoration: const InputDecoration(
                        labelText: 'Enter your phone number',
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                      onChanged: (value) {
                        if (!value.startsWith('254 ')) {
                          _phoneController.text = '254 ';
                          _phoneController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _phoneController.text.length),
                          );
                        } else if (value.length > 13) {
                          _phoneController.text = value.substring(0, 13);
                          _phoneController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _phoneController.text.length),
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null) return 'Enter a valid phone number (254 XXXXXXXXX)';

                        String sanitizedValue = value.replaceAll(' ', '');
                        if (!RegExp(r'^254[0-9]{9}$').hasMatch(sanitizedValue)) {
                          return 'Enter a valid phone number (254 XXXXXXXXX)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String fullNumber = _phoneController.text.replaceAll(' ', '');
                          _sendSTKPush(fullNumber);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontFamily: "SmoochSans-VariableFont_wght.ttf",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AlreadyPaid()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                      ),
                      child: const Text(
                        'Already Paid',
                        style: TextStyle(
                          fontFamily: "SmoochSans-VariableFont_wght.ttf",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

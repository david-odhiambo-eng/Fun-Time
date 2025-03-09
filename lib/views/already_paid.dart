import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenyan_game/server.dart';
import 'package:kenyan_game/subscription.dart';
import 'package:kenyan_game/views/payment_page.dart';

import '../global.dart';
import '../progress.dart';
import 'landing_page.dart';

class AlreadyPaid extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<AlreadyPaid> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _phoneController.text = '254 ';
  }

  Future<void> confirmSub(String phoneNumber) async {
    Dialogs().showLoadingDialog("Please wait");
    await Subscription().confirmSubscription(phoneNumber, callback);
  }

  void callback(bool isSuccess, dynamic data) {
    Navigator.of(navigatorKey.currentContext!).pop();
    if (isSuccess) {
      final status = data["subscription_status"];
      final validTill = data["valid_till"];
      Dialogs().showSnackBar("Your subscription status: $status");
      if (user != null) {
        SubscriptionService().saveSubscriptionData(user!, status, validTill);
      }
      if (status == "active") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      } else {
        showSubscriptionDialog(navigatorKey.currentContext!, "Your subscription has expired!");
      }
    } else {
      Dialogs().showSnackBar(data);
      showSubscriptionDialog(navigatorKey.currentContext!, data);
    }
  }

  void showSubscriptionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Subscription Required"),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              child: const Text("Continue"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Pay Now"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disables back navigation
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Alpha Client',
            style: TextStyle(fontFamily: "SmoochSans-VariableFont_wght.ttf"),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 13,
                        decoration: const InputDecoration(
                          labelText: 'Confirm phone number',
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String fullNumber = _phoneController.text.replaceAll(' ', '');
                            confirmSub(fullNumber);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: "SmoochSans-VariableFont_wght.ttf",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

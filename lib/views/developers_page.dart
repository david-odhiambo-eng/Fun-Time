import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperContactPage extends StatelessWidget {
  final List<Map<String, String>> developers = [
    {
      "name": "David Odhiambo",
      "role": "Lead Developer",
      "email": "odhiambodavid305@gmail.com",
    },
    {
      "name": "Anthony Alando",
      "role": "Backend Engineer",
      "email": "anthonyalando8@gmail.com",
    },
  ];

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull('subject=Hello Developer&body=Hi, I would like to...'),
    );

    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $emailUri';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Developers"),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[300],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: developers.map((dev) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dev["name"]!,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dev["role"]!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                      Divider(),
                      IconButton(
                        icon: Icon(Icons.email, color: Colors.blue),
                        onPressed: () => _sendEmail(dev["email"]!),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

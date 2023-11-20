import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(title: Text("Notification"),),
      body: Column(
        children: [
          Text(message.notification!.title.toString()),
          Text(message.notification!.body.toString()),
          Text(message.data.toString()),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                sendMessage("Udaje ze pracuje");
              },
              child: Text('Udaje'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(26.0),
            child: ElevatedButton(
              onPressed: () {
                sendMessage("Korek jest");
              },
              child: Text('Korek'),
            ),
          )
        ],
      ),
    );
  }

  void sendMessage(String message) {
    // sendToApi(); //TODO
    print(message);
  }
}
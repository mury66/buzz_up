import 'package:buzz_up/models/message_model.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = '/chat';
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen1'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.of(context).pop(); },
        ),
      ),
      body: Container(
        color: Colors.black26,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chat.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BubbleSpecialThree(
                        text: chat[index].content,
                        color: chat[index].role == "sender" ? Colors.green : Colors.grey,
                        tail: true,
                        isSender: chat[index].role == "sender",
                      ),
                    );
                  }
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Colors.black26,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {

                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green,),
                    onPressed: () {
                      chat.add(MessageModel(senderId: "sender", content: messageController.text, time: DateTime.now(), id: DateTime.now().toString()));
                      messageController.clear();
                      setState((){});
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

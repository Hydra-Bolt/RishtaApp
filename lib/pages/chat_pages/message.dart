import 'package:flutter/material.dart';

class MyMessageSectionWidget extends StatelessWidget {
  final List<Message> messages;

  const MyMessageSectionWidget({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      shrinkWrap: true,
      padding: const EdgeInsets.all(15),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MyMessageBubbleWidget(
          isMe: message.isMe,
          message: message.message,
        );
      },
    );
  }
}

class MyMessageBubbleWidget extends StatelessWidget {
  const MyMessageBubbleWidget({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;
  final String message;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.7;
    const double radius = 20;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: width),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: isMe
                ? const Color.fromARGB(255, 88, 152, 36)
                : const Color.fromARGB(255, 39, 139, 103),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(radius),
              topRight: const Radius.circular(radius),
              bottomLeft: isMe ? const Radius.circular(radius) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(radius),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
            softWrap: true,
            maxLines: 20,
          ),
        ),
      ),
    );
  }
}

class Message {
  String? id;
  final String message;
  DateTime? messageSentTime;
  final int chatboxId;
  final bool showMessage;
  final bool isMe;
  bool isSent;

  Message({
    this.id,
    this.messageSentTime,
    required this.message,
    required this.chatboxId,
    required this.isMe,
    this.showMessage = true,
    this.isSent = true,
  });

  Map<String, dynamic> toMap(String uid) {
    return {
      'message': message,
      'chatbox_id': chatboxId,
      'sender': uid,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/pages/chat_pages/message.dart';
import 'package:supabase_auth/utilities/input_text_field.dart';
import 'package:supabase_auth/utils/db_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyChatScreenUI extends StatefulWidget {
  final Map<String, dynamic> chatBoxDetails;

  const MyChatScreenUI({super.key, required this.chatBoxDetails});

  @override
  State<MyChatScreenUI> createState() => _MyChatScreenUIState();
}

class _MyChatScreenUIState extends State<MyChatScreenUI> {
  String? channelName;
  final String _uid = supabase.auth.currentUser!.id;
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final DBService _service = DBService();
  late RealtimeChannel channel;
  bool areNewFriends = false;

  @override
  void initState() {
    super.initState();
    channelName = "ChatChannel${widget.chatBoxDetails['chatID']}";
    _fetchMessages(widget.chatBoxDetails['chatID']);
  }

  void _addSupabaseMessageListener() {
    channel = supabase
        .channel(channelName!)
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'Message',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'chatbox_id',
              value: widget.chatBoxDetails['chatID'],
            ),
            callback: (payload) {
              bool showMsgFor = false;

              final bool isMe = payload.newRecord['sender'] == _uid;

              switch (payload.newRecord['deleted_for']) {
                case 'None':
                  showMsgFor = true;
                  break;
                case 'Sender':
                  showMsgFor = isMe ? false : true;
                  break;
                case 'Receiver':
                  showMsgFor = isMe;
                  break;
                case 'Both':
                  showMsgFor = false;
                  break;
              }

              final newMessage = Message(
                  id: payload.newRecord['id'],
                  isMe: isMe,
                  chatboxId: payload.newRecord['chatbox_id'],
                  message: payload.newRecord['message'],
                  messageSentTime:
                      DateTime.parse(payload.newRecord['message_sent_time']),
                  showMessage: showMsgFor);

              if (payload.oldRecord.isNotEmpty) {
                String? change = payload.oldRecord['deleted_for'];
                if (change == 'None' && showMsgFor) {
                  setState(() {
                    _messages.insert(0, newMessage);
                  });
                } else if (change != 'None' && showMsgFor == false) {
                  setState(() {
                    _messages.removeWhere(
                      (element) {
                        return element.id == newMessage.id;
                      },
                    );
                  });
                }
              } else {
                setState(() {
                  _messages.insert(0, newMessage);
                });
              }
            })
        .subscribe();
  }

  void _fetchMessages(int chatBoxID) async {
    try {
      final List<dynamic> response =
          await _service.getMessagesFromChatBoxID(chatBoxID);
      if (response.isEmpty) {
        setState(() {
          areNewFriends = true;
        });
      } else {
        setState(() {
          _messages.clear();
          _messages.addAll(
            response.map((msg) {
              bool? showMsgFor;
              final bool isMe = msg['sender'] == _uid;

              switch (msg['deleted_for']) {
                case 'None':
                  showMsgFor = true;
                  break;
                case 'Sender':
                  showMsgFor = isMe ? false : true;
                  break;
                case 'Receiver':
                  showMsgFor = isMe;
                  break;
                case 'Both':
                  showMsgFor = false;
                  break;
              }
              return Message(
                  id: msg['id'],
                  isMe: isMe,
                  chatboxId: msg['chatbox_id'],
                  message: msg['message'],
                  messageSentTime: DateTime.parse(msg['message_sent_time']),
                  showMessage: showMsgFor!);
            }),
          );
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> _addMessage(String message) async {
    final Message msg = Message(
      isMe: true,
      message: message,
      chatboxId: widget.chatBoxDetails['chatID'],
      isSent: false,
    );

    if (areNewFriends) {
      final data = msg.toMap(_uid);
      final response = await _service.addMessageUsingChatBoxID(data);
      if (response != null) {
        msg.isSent = true;
        msg.id = response[0]['id'];
        msg.messageSentTime = DateTime.parse(response[0]['message_sent_time']);
        setState(() {
          _messages.insert(0, msg);
        });
        _addSupabaseMessageListener();
      }
    }

    // Send the message to the database (implement the logic accordingly)
    // Example:

    // Uncomment this if you handle the response from the database

    _messageController.clear();
  }

  void _deleteMessage(String messageId, bool forMe) async {
    String? deletesFor;

    final Message selectedMessage = _messages.firstWhere(
      (msg) => msg.id == messageId,
    );

    if (forMe && selectedMessage.isMe) {
      deletesFor = "Sender";
    } else if (forMe && !selectedMessage.isMe) {
      deletesFor = "Receiver";
    } else if (!forMe && selectedMessage.isMe) {
      deletesFor = "Both";
    }

    await _service.removeMessageUsingChatBoxID(
        selectedMessage.chatboxId, selectedMessage.id!, deletesFor!);
    setState(() {
      _messages.removeWhere((msg) => msg.id == messageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.chatBoxDetails['chatFullName'],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 233, 233),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/cutie.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 246, 233, 233).withOpacity(0.9),
              backgroundBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            maintainBottomViewPadding: false,
            child: Column(
              children: [
                const Divider(
                  height: 4,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: MyMessageSectionWidget(
                              messages: _messages,
                              onDeleteMessage: _deleteMessage,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 7),
                          height: 80, // Fixed height for input field
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: MyTextFormInputField(
                                    isEnabled:
                                        widget.chatBoxDetails['enableChat'],
                                    controller: _messageController,
                                    textHint: "Say Hi",
                                    keyboardType: TextInputType.multiline,
                                    obscureText: false,
                                    prefixIcon: false,
                                    bgColor: Colors.grey.shade300,
                                    validatorCallback: (arg) {
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                  size: 27,
                                ),
                                onPressed: () {
                                  if (_messageController.text.isNotEmpty) {
                                    _addMessage(_messageController.text);
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyMessageSectionWidget extends StatelessWidget {
  final List<Message> messages;
  final void Function(String, bool) onDeleteMessage;

  const MyMessageSectionWidget({
    super.key,
    required this.messages,
    required this.onDeleteMessage,
  });

  bool messageSentElapsedTimeGreater(Message msg) {
    const int allowedDuration = 2;
    return msg.messageSentTime!.difference(DateTime.now()).abs().inHours <=
        allowedDuration;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.5;
    // final double height = MediaQuery.of(context).size.height;
    const double radius = 25;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (!message.showMessage) {
          return const SizedBox.shrink();
        }
        return GestureDetector(
            onLongPress: () {
              messageSentElapsedTimeGreater(message)
                  ? showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Message Options"),
                        content:
                            const Text("Do you want to delete this message?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              onDeleteMessage(message.id!, true);
                              Navigator.pop(context);
                            },
                            child: const Text("Delete For Me"),
                          ),
                          if (message.isMe)
                            TextButton(
                              onPressed: () {
                                onDeleteMessage(message.id!, false);
                                Navigator.pop(context);
                              },
                              child: const Text("Delete For Everyone"),
                            ),
                        ],
                      ),
                    )
                  : showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(const Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          title: const Text("Message Options"),
                          content: const Text("Message cannot be deleted."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"),
                            ),
                          ],
                        );
                      },
                    );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Align(
                alignment:
                    message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: width),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? message.isSent
                            ? const Color.fromARGB(255, 234, 131, 233)
                            : const Color.fromARGB(255, 207, 104, 88)
                        : const Color.fromARGB(255, 135, 79, 141),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(radius),
                      topRight: const Radius.circular(radius),
                      bottomLeft: message.isMe
                          ? const Radius.circular(radius)
                          : Radius.zero,
                      bottomRight: message.isMe
                          ? Radius.zero
                          : const Radius.circular(radius),
                    ),
                  ),
                  child: Text(
                    message.message,
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
            ));
      },
    );
  }
}

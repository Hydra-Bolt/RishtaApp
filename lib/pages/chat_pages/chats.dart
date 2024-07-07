import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/pages/chat_pages/chatbox_creator.dart';
import 'package:supabase_auth/utils/db_service.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final String myUsername =
      supabase.auth.currentUser!.userMetadata!['username'];
  late final DBService service;

  @override
  void initState() {
    super.initState();
    service = DBService();
  }

  Future<List<Map<String, dynamic>>> _fetchChats(String uid) async {
    try {
      final service = DBService(); // Instantiate DBService
      final response = await service.getUserChatsFromUID(uid);

      final List<Map<String, dynamic>> chats = [];
      for (var element in response) {
        final Map<String, dynamic> chat = {
          'chatID': element['id'],
          'chatFullName': element['user1'] == uid
              ? element['Chats_user2_fkey']['first_name'] +
                  " " +
                  element['Chats_user2_fkey']['last_name']
              : element['Chats_user1_fkey']['first_name'] +
                  " " +
                  element['Chats_user1_fkey']['last_name'],
          'chatUsername': element['user1'] == uid
              ? element['Chats_user2_fkey']['username']
              : element['Chats_user1_fkey']['username'],
          'chatUser': element['user1'] == uid ? 'user2' : 'user1',
          'chatUserUID':
              element['user1'] == uid ? element['user2'] : element['user1'],
          'enableChat': element['friends'] == 'Yes',
          'me': myUsername,
          // Same setup for Last Message and Email will be done in the future. If needed.
        };
        chats.add(chat);
      }
      print('Chats $chats');

      return chats;
    } on Exception catch (e) {
      print(e);
      return []; // Return an empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.message_outlined,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Divider(
            color: Colors.black,
            thickness: 2,
            indent: 30,
            endIndent: 30,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchChats(supabase.auth.currentUser!.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.black,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final chatBoxData = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding:
                            const EdgeInsets.only(top: 4, left: 14, right: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40),
                          ),
                        ),
                        child: MyChatBoxCardsSectionCreator(
                          service: service,
                          chatsData: chatBoxData,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Text(
                  "No Chats Available.",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}

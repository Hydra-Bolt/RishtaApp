import 'package:flutter/material.dart';
import 'package:supabase_auth/pages/chat_pages/chat_screen.dart';
import 'package:supabase_auth/pages/chat_pages/chatbox_cards.dart';
import 'package:supabase_auth/utils/db_service.dart';

class MyChatBoxCardsSectionCreator extends StatelessWidget {
  final DBService service;
  final List<Map<String, dynamic>> chatsData;

  const MyChatBoxCardsSectionCreator({
    super.key,
    required this.service,
    required this.chatsData,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      bottom: true,
      child: ListView.builder(
        itemCount: chatsData.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final chat = chatsData[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyChatScreenUI(
                    chatBoxDetails: chat,
                  ),
                ),
              );
            },
            child: MyChatBoxCard(
              cardImage: chat['cardImage'] ?? 'assets/icons/Profile.png',
              cardName: chat['chatUsername'] ?? 'Unknown',
              cardDescription: chat['chatFullName'],
            ),
          );
        },
      ),
    );
  }
}

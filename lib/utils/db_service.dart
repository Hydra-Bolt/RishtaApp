import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DBService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Function to fetch user chats based on userID
  Future<List<Map<String, dynamic>>> getUserChatsFromUID(
      String identifier) async {
    try {
      final response = await _supabase
          .from('Chats')
          .select(
              'id, user1, user2, friends, Chats_user1_fkey(first_name, last_name, username), Chats_user2_fkey(first_name, last_name, username)')
          .or('user1.eq.$identifier, user2.eq.$identifier');

      return response;
    } catch (e) {
      print('Error fetching user chats: $e');
      rethrow;
    }
  }

  // Function to get messages for a chatbox ID using RPC
  Future<List<dynamic>> getMessagesFromChatBoxID(int identifier) async {
    try {
      final response = await _supabase.rpc('get_messages_for_chatbox', params: {
        'chat_id': identifier,
      });

      // Handle the response data as needed
      print(response);

      return response;
    } catch (e) {
      print('Error fetching messages: $e');
      rethrow;
    }
  }

  Future<dynamic> addMessageUsingChatBoxID(int identifier, Map data) async {
    try {
      final response = await _supabase.from('Message').insert(data).select();
      return response;
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<bool> removeMessageUsingChatBoxID(
      int chatBoxID, String messageID, String deleteFor) async {
    try {
      final prevRecord = await _supabase
          .from('Message')
          .select()
          .eq('id', messageID)
          .eq('chatbox_id', chatBoxID);

      String? updateDeletedFor;
      switch (prevRecord[0]['deleted_for']) {
        case 'None':
          updateDeletedFor = deleteFor;
          break;

        case 'Sender':
          updateDeletedFor = 'Both';
          break;

        case 'Receiver':
          updateDeletedFor = 'Both';
          break;

        // This case is not going to appear but for the sake of handling added it.
        case 'Both':
          break;
      }

      bool response = false;

      if (updateDeletedFor != null) {
        response = await _supabase
            .from('Message')
            .update({'deleted_for': updateDeletedFor})
            .eq('id', messageID)
            .eq('chatbox_id', chatBoxID)
            .then((value) => true)
            .onError((error, stackTrace) => false);
      }
      return response;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }
}

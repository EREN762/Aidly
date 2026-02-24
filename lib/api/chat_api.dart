import 'dart:convert';

import 'package:http/http.dart' as http;

import '../ui_models/chat_message.dart';
import 'api_config.dart';

class ChatApi {
  Future<List<ChatMessage>> fetchMessages(String serviceId) async {
    final response = await http.get(
      ApiConfig.resolve('/api/chat/$serviceId'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erreur chargement messages (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessage> sendMessage({
    required String serviceId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final response = await http.post(
      ApiConfig.resolve('/api/chat/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'serviceId': serviceId,
        'senderId': senderId,
        'receiverId': receiverId,
        'content': content,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erreur envoi message (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ChatMessage.fromJson(data);
  }
}

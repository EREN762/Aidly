import 'package:flutter/material.dart';

import '../api/chat_api.dart';
import '../ui_models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(this._chatApi);

  final ChatApi _chatApi;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;

  Future<void> loadMessages(String serviceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _chatApi.fetchMessages(serviceId);
      _messages
        ..clear()
        ..addAll(data);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String serviceId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;
    _isSending = true;
    notifyListeners();
    try {
      final message = await _chatApi.sendMessage(
        serviceId: serviceId,
        senderId: senderId,
        receiverId: receiverId,
        content: content.trim(),
      );
      _messages.add(message);
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../services/chat_firestore_service.dart';
import '../ui_models/chat_message.dart';

/// Provider de chat temps réel (Firestore).
/// Appeler [startListening] à l’ouverture du chat et [stopListening] au démontage.
class ChatProvider extends ChangeNotifier {
  ChatProvider(this._service, {required this.chatId, required this.serviceId});

  final ChatFirestoreService _service;
  final String chatId;
  final String serviceId;

  StreamSubscription<List<ChatMessage>>? _subscription;
  final List<ChatMessage> _messages = [];
  bool _isSending = false;
  String? _error;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isSending => _isSending;
  String? get error => _error;

  /// Démarre l’écoute temps réel des messages.
  void startListening() {
    _error = null;
    _subscription?.cancel();
    _subscription = _service.streamMessages(chatId).listen(
      (list) {
        _messages
          ..clear()
          ..addAll(list);
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  /// Arrête l’écoute (à appeler au dispose du ChatScreen).
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;
    _isSending = true;
    _error = null;
    notifyListeners();
    try {
      await _service.sendMessage(
        chatId: chatId,
        serviceId: serviceId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
      );
      // Le stream met à jour _messages automatiquement
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../ui_models/chat_message.dart';

/// Service de chat temps réel basé sur Firestore.
/// Structure : `chats/{chatId}/messages` avec chatId stable client/prestataire/service.
class ChatFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Identifiant de conversation stable (même id pour client et prestataire).
  static String chatId({
    required String serviceId,
    required String clientId,
    required String providerId,
  }) {
    final parts = [clientId, providerId]..sort();
    return '${serviceId}_${parts.join('_')}';
  }

  CollectionReference<Map<String, dynamic>> _messagesRef(String chatId) {
    return _firestore.collection('chats').doc(chatId).collection('messages');
  }

  /// Écoute des messages en temps réel (ordre chronologique).
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return _messagesRef(chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  /// Envoi d’un message (écriture Firestore ; le stream met à jour l’UI).
  Future<ChatMessage> sendMessage({
    required String chatId,
    required String serviceId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final ref = _messagesRef(chatId).doc();
    final message = ChatMessage(
      messageId: ref.id,
      senderId: senderId,
      receiverId: receiverId,
      content: content.trim(),
      timestamp: DateTime.now(),
      serviceId: serviceId,
    );
    await ref.set(message.toFirestore());
    return message;
  }
}

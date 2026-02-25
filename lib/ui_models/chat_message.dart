import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.serviceId,
  });

  final String messageId;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  /// Optionnel : identifiant du service (pour filtre / cohérence Firestore).
  final String? serviceId;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      serviceId: json['serviceId']?.toString(),
    );
  }

  /// Création à partir d’un document Firestore (temps réel).
  factory ChatMessage.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final ts = data['timestamp'];
    final DateTime dateTime = ts is Timestamp
        ? ts.toDate()
        : DateTime.tryParse(ts?.toString() ?? '') ?? DateTime.now();
    return ChatMessage(
      messageId: doc.id,
      senderId: data['senderId']?.toString() ?? '',
      receiverId: data['receiverId']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      timestamp: dateTime,
      serviceId: data['serviceId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      if (serviceId != null) 'serviceId': serviceId,
    };
  }

  /// Pour l’écriture Firestore (timestamp = DateTime).
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
      if (serviceId != null) 'serviceId': serviceId,
    };
  }
}

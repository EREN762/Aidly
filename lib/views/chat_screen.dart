import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../services/chat_firestore_service.dart';
import '../ui_models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.serviceId,
    required this.clientId,
    required this.providerId,
    required this.providerName,
  });

  final String serviceId;
  final String clientId;
  final String providerId;
  final String providerName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  int _lastMessageCount = 0;
  ChatProvider? _chatProvider;

  @override
  void dispose() {
    _chatProvider?.stopListening();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatId = ChatFirestoreService.chatId(
      serviceId: widget.serviceId,
      clientId: widget.clientId,
      providerId: widget.providerId,
    );
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(
        ChatFirestoreService(),
        chatId: chatId,
        serviceId: widget.serviceId,
      )..startListening(),
      child: Builder(
        builder: (context) {
          final provider = context.watch<ChatProvider>();
          _chatProvider ??= provider;
          final messages = provider.messages;
          if (messages.length != _lastMessageCount) {
            _lastMessageCount = messages.length;
            _scrollToBottom();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.providerName),
            ),
            body: Column(
              children: [
                if (provider.error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      provider.error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                Expanded(
                  child: NotificationListener<ScrollEndNotification>(
                          onNotification: (_) {
                            _scrollToBottom();
                            return false;
                          },
                          child: ListView.builder(
                            key: const PageStorageKey('chat-list'),
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMe =
                                  message.senderId == widget.clientId;
                              return _MessageBubble(
                                message: message,
                                isMe: isMe,
                              );
                            },
                          ),
                        ),
                ),
                _Composer(
                  controller: _messageController,
                  isSending: provider.isSending,
                  onSend: () async {
                    final text = _messageController.text;
                    _messageController.clear();
                    await provider.sendMessage(
                      senderId: widget.clientId,
                      receiverId: widget.providerId,
                      content: text,
                    );
                    _scrollToBottom();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final textColor = isMe ? Colors.white : theme.colorScheme.onSurface;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Ecrire un message',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: isSending ? null : onSend,
              icon: isSending
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

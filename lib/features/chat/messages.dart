import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:abodesv1/core/constants/app_colors.dart';
import 'package:abodesv1/core/constants/app_theme.dart';
import 'package:abodesv1/features/chat/chat_encryption.dart';
import 'package:abodesv1/features/chat/chat_model.dart';


class EncryptedChatScreen extends StatefulWidget {
  final String ownerId;
  final String seekerId;

  const EncryptedChatScreen({
    super.key,
    required this.ownerId,
    required this.seekerId,
  });

  @override
  State<EncryptedChatScreen> createState() => _EncryptedChatScreenState();
}

class _EncryptedChatScreenState extends State<EncryptedChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final _uuid = const Uuid();
  late final String _currentUserId;
  late final String _threadId;
  late final DatabaseReference _messageRef;

  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User must be logged in to chat.");
    _currentUserId = user.uid;

    final ids = [_currentUserId, widget.ownerId == _currentUserId ? widget.seekerId : widget.ownerId];
    ids.sort(); // Ensure consistent thread ID regardless of sender order
    _threadId = ids.join("_");

    _messageRef = FirebaseDatabase.instance.ref('chats/$_threadId/messages');
    _listenToMessages();
  }

  void _listenToMessages() {
    _messageRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<ChatMessage> loaded = [];

        data.forEach((key, value) {
          final decryptedContent = EncryptionService.decryptText(value['content']);
          final msg = ChatMessage(
            id: value['id'],
            senderId: value['senderId'],
            receiverId: value['receiverId'],
            content: decryptedContent,
            status: value['status'],
            timestamp: value['timestamp'],
          );
          loaded.add(msg);
        });

        loaded.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        setState(() => messages = loaded);

        for (final msg in loaded) {
          if (msg.receiverId == _currentUserId && msg.status != 'read') {
            _messageRef.child(msg.id).update({'status': 'read'});
          }
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final encrypted = EncryptionService.encryptText(text);
    final messageId = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final receiverId = widget.ownerId == _currentUserId ? widget.seekerId : widget.ownerId;

    final newMessage = ChatMessage(
      id: messageId,
      senderId: _currentUserId,
      receiverId: receiverId,
      content: encrypted,
      status: 'sent',
      timestamp: now,
    );

    await _messageRef.child(messageId).set(newMessage.toMap());
    _controller.clear();
  }

  Widget _buildBubble(ChatMessage message) {
    final isMe = message.senderId == _currentUserId;
    final time = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(message.timestamp));
    IconData statusIcon = Icons.check;
    Color statusColor = Colors.grey;

    if (message.status == 'delivered') {
      statusIcon = Icons.done_all;
    } else if (message.status == 'read') {
      statusIcon = Icons.done_all;
      statusColor = Colors.blue;
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.content, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                const SizedBox(width: 4),
                if (isMe) Icon(statusIcon, size: 14, color: statusColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Encrypted Chat'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) => _buildBubble(messages[index]),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.borderDefault),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

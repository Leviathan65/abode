import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:abodesv1/features/chat/messages.dart';
import 'package:abodesv1/features/chat/chat_encryption.dart';


class MessagesListPage extends StatefulWidget {
  final String currentUserId;
  final bool isOwner;

  const MessagesListPage({
    super.key,
    required this.currentUserId,
    required this.isOwner,
  });

  @override
  State<MessagesListPage> createState() => _MessagesListPageState();
}

class _MessagesListPageState extends State<MessagesListPage> {
  final DatabaseReference _chatRef = FirebaseDatabase.instance.ref('chats');
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref('users');
  List<Map<String, dynamic>> _conversations = [];
  final Map<String, String> _userNames = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    final snapshot = await _chatRef.get();
    if (!snapshot.exists) return;

    final Map data = snapshot.value as Map;
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var thread in data.entries) {
      final threadData = Map<String, dynamic>.from(thread.value);
      if (!threadData.containsKey('messages')) continue;

      final Map messagesInThread = Map<String, dynamic>.from(threadData['messages']);

      for (var msgEntry in messagesInThread.entries) {
        final msg = Map<String, dynamic>.from(msgEntry.value);

        final isRelevant = msg['senderId'] == widget.currentUserId || msg['receiverId'] == widget.currentUserId;
        if (!isRelevant) continue;

        final counterpartId = msg['senderId'] == widget.currentUserId
            ? msg['receiverId']
            : msg['senderId'];

        grouped.putIfAbsent(counterpartId, () => []);
        grouped[counterpartId]!.add(msg);
      }
    }

    // Fetch user names
    for (final userId in grouped.keys) {
      final userSnapshot = await _userRef.child(userId).child('first_name').get();
      _userNames[userId] = userSnapshot.value?.toString() ?? 'Unknown';
    }

    final List<Map<String, dynamic>> convoList = [];
    grouped.forEach((otherUserId, msgs) {
      msgs.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      final latest = msgs.first;

      // Decrypt the latest message
      final decryptedContent = EncryptionService.decryptText(latest['content']);


      convoList.add({
        'userId': otherUserId,
        'userName': _userNames[otherUserId] ?? 'Unknown',
        'lastMessage': decryptedContent,
        'timestamp': latest['timestamp'],
        'unreadCount': msgs.where((m) =>
        m['receiverId'] == widget.currentUserId &&
            m['status'] == 'sent').length,
      });
    });

    setState(() {
      _conversations = convoList;
      _loading = false;
    });
  }

  String _formatTime(int ts) {
    return DateFormat('hh:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(ts),
    );
  }

  Widget _buildItem(Map<String, dynamic> convo) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      leading: CircleAvatar(
        backgroundColor: Colors.indigo,
        child: Text(
          convo['userName'][0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(convo['userName'], style: TextStyle(fontSize: 15.sp)),
      subtitle: Text(
        convo['lastMessage'],
        style: TextStyle(fontSize: 13.sp),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_formatTime(convo['timestamp']), style: TextStyle(fontSize: 11.sp)),
          if (convo['unreadCount'] > 0)
            Container(
              margin: EdgeInsets.only(top: 4.h),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${convo['unreadCount']}',
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
              ),
            ),
        ],
      ),
      onTap: () {
        final ownerId = widget.isOwner ? widget.currentUserId : convo['userId'];
        final seekerId = widget.isOwner ? convo['userId'] : widget.currentUserId;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EncryptedChatScreen(
              ownerId: ownerId,
              seekerId: seekerId,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
          ? Center(child: Text('No messages found', style: TextStyle(fontSize: 14.sp)))
          : ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (_, i) => _buildItem(_conversations[i]),
      ),
    );
  }
}

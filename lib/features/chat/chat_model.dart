class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String status; // 'sent', 'delivered', 'read'
  final int timestamp; // Epoch in milliseconds

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.status,
    required this.timestamp,
  });

  /// Converts this message into a JSON-compatible map for Firebase.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'status': status,
      'timestamp': timestamp,
    };
  }

  /// Creates a ChatMessage from a Firebase snapshot map.
  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      content: map['content'] as String,
      status: map['status'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}

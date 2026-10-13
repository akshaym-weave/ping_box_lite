class ChatThread {
  const ChatThread(
      {required this.id,
      required this.name,
      required this.preview,
      required this.unread,
      required this.updatedAt});
  final String id, name, preview;
  final int unread, updatedAt;

  factory ChatThread.fromJson(Map<String, Object?> json) {
    int number(Object? value) =>
        value is int ? value : int.tryParse('$value') ?? 0;
    final unread = json['unread'] as int;
    return ChatThread(
      id: json['id'] as String,
      name: json['name'] as String,
      preview: json['preview'] as String,
      unread: unread < 0 ? 0 : unread,
      updatedAt: number(json['updatedAt']),
    );
  }

  ChatThread markRead() => ChatThread(
      id: id, name: name, preview: preview, unread: 0, updatedAt: updatedAt);
}

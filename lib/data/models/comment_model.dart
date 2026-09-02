class CommentModel {
  final int? id;
  final int postId;
  final int userId;
  final String text;
  final String timestamp;
  final String username; // Captured via SQL JOIN

  CommentModel({
    this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.username,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      postId: map['post_id'],
      userId: map['user_id'],
      text: map['text'],
      timestamp: map['timestamp'],
      username: map['username'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}

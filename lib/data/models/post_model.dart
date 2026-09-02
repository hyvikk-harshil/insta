class PostModel {
  final int? id;
  final int userId;
  final String imagePath;
  final String caption;
  final String timestamp;

  // These fields come from joining the User table
  final String username;
  final String userProfilePic;

  // Track if current user liked it (0 = false, 1 = true)
  int isLiked;

  PostModel({
    this.id,
    required this.userId,
    required this.imagePath,
    required this.caption,
    required this.timestamp,
    required this.username,
    required this.userProfilePic,
    this.isLiked = 0,
  });

  // Convert SQL Map to Dart Object
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      userId: map['user_id'],
      imagePath: map['image_path'],
      caption: map['caption'],
      timestamp: map['timestamp'],
      username: map['username'] ?? 'unknown',
      userProfilePic: map['profile_pic'] ?? '',
      isLiked: map['is_liked'] ?? 0,
    );
  }

  // Convert Dart Object to SQL Map (For inserting a new post)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'image_path': imagePath,
      'caption': caption,
      'timestamp': timestamp,
    };
  }
}

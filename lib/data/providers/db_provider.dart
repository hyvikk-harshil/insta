import '../database/db_helper.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

class DbProvider {
  final DbHelper _dbHelper = DbHelper.instance;

  // Add these functions inside your DbProvider class in db_provider.dart

  Future<List<CommentModel>> getCommentsForPost(int postId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT comments.*, users.username 
    FROM comments
    INNER JOIN users ON comments.user_id = users.id
    WHERE comments.post_id = ?
    ORDER BY comments.id ASC
  ''', [postId]);

    return List.generate(maps.length, (i) => CommentModel.fromMap(maps[i]));
  }

  Future<int> insertComment(CommentModel comment) async {
    final db = await _dbHelper.database;
    return await db.insert('comments', comment.toMap());
  }
  
  // Fetch the main feed with custom JOIN queries
  Future<List<PostModel>> getHomeFeed(int currentUserId) async {
    final db = await _dbHelper.database;

    // This query pulls the post details, the author's details,
    // and checks if the current user has liked it using a subquery.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        posts.*, 
        users.username, 
        users.profile_pic,
        EXISTS(
          SELECT 1 FROM likes 
          WHERE likes.post_id = posts.id AND likes.user_id = ?
        ) AS is_liked
      FROM posts
      INNER JOIN users ON posts.user_id = users.id
      ORDER BY posts.id DESC
    ''', [currentUserId]);

    return List.generate(maps.length, (i) => PostModel.fromMap(maps[i]));
  }

  // Insert a new post
  Future<int> insertPost(PostModel post) async {
    final db = await _dbHelper.database;
    return await db.insert('posts', post.toMap());
  }

  // Like / Unlike action
  Future<void> toggleLike(int postId, int userId) async {
    final db = await _dbHelper.database;

    // Check if like exists
    List<Map> result = await db.query(
        'likes',
        where: 'post_id = ? AND user_id = ?',
        whereArgs: [postId, userId]
    );

    if (result.isEmpty) {
      // Like
      await db.insert('likes', {'post_id': postId, 'user_id': userId});
    } else {
      // Unlike
      await db.delete(
          'likes',
          where: 'post_id = ? AND user_id = ?',
          whereArgs: [postId, userId]
      );
    }
  }
}

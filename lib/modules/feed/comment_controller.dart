import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/providers/db_provider.dart';

class CommentsController extends GetxController {
  final DbProvider _dbProvider = DbProvider();
  final int postId;

  var isLoading = true.obs;
  var commentsList = <CommentModel>[].obs;
  final commentInputController = TextEditingController();

  CommentsController({required this.postId});

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      isLoading(true);
      var comments = await _dbProvider.getCommentsForPost(postId);
      commentsList.assignAll(comments);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addComment() async {
    if (commentInputController.text.trim().isEmpty) return;

    try {
      final newComment = CommentModel(
        postId: postId,
        userId: 1, // Logged in user mock ID
        text: commentInputController.text.trim(),
        timestamp: DateTime.now().toString(),
        username: 'my_username',
      );

      await _dbProvider.insertComment(newComment);
      commentInputController.clear();

      // Reload comments list instantly
      fetchComments();
    } catch (e) {
      Get.snackbar("Error", "Could not save comment.");
    }
  }

  @override
  void onClose() {
    commentInputController.dispose();
    super.onClose();
  }
}

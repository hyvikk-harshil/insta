import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'comment_controller.dart';

class CommentsSheet extends StatelessWidget {
  final int postId;
  const CommentsSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    // Dynamically inject a temporary isolated controller unique to this specific opened post
    final controller = Get.put(CommentsController(postId: postId), tag: postId.toString());

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),

          // Comment Feed List Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.black));
              }
              if (controller.commentsList.isEmpty) {
                return const Center(child: Text("Be the first to comment!", style: TextStyle(color: Colors.grey)));
              }
              return ListView.builder(
                itemCount: controller.commentsList.length,
                itemBuilder: (context, index) {
                  final comment = controller.commentsList[index];
                  return ListTile(
                    leading: const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 14)),
                    title: Text(comment.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(comment.text, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                  );
                },
              );
            }),
          ),

          // Input Action Bar Box
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 12, right: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.commentInputController,
                      decoration: const InputDecoration(hintText: "Add a comment...", border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () => controller.addComment(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

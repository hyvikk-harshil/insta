import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'commets_seet.dart';
import 'feed_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.toNamed('/new-post'),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Instagram',
          style: TextStyle(
            fontFamily: 'Billabong', // You can add an Instagram-like font later
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () => Get.toNamed('/profile'), // Navigates cleanly via GetX
          ),
        ],
      ),
      // Obx listens directly to the controller state changes
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (controller.postList.isEmpty) {
          return const Center(child: Text("No posts found. Add some!"));
        }

        return ListView.builder(
          itemCount: controller.postList.length,
          itemBuilder: (context, index) {
            final post = controller.postList[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Post Header (User Profile Image & Username)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white), // Standard fallback
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Icon(Icons.more_vert),
                    ],
                  ),
                ),

                // 2. Post Image (Using a placeholder for local setup)
                // Locate the Container(width: double.infinity, height: 400...) block and update it to this:
                Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.grey[100],
                  child: post.imagePath.startsWith('assets/')
                      ? Image.asset(post.imagePath, fit: BoxFit.cover) // Plays original seeded posts
                      : Image.file(File(post.imagePath), fit: BoxFit.cover), // Plays gallery uploads
                ),


                // 3. Action Buttons (Like, Comment, Share)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked == 1 ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked == 1 ? Colors.red : Colors.black,
                      ),
                      onPressed: () => controller.toggleLikePost(post.id!, index),
                    ),

                    // COMMENT BUTTON: Launches bottom canvas sheet overlay
                    IconButton(
                      icon: const Icon(Icons.maps_ugc_outlined, color: Colors.black),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CommentsSheet(postId: post.id!),
                        );
                      },
                    ),

                    // SHARE BUTTON: Launches OS system sheet trays
                    IconButton(
                      icon: const Icon(Icons.send_outlined, color: Colors.black),
                      onPressed: () => controller.sharePost(post),
                    ),
                  ],
                ),


                // 4. Captions & Timestamps
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '${post.username} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: post.caption),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            );
          },
        );
      }),
    );
  }
}

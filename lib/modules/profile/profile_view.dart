import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Refresh the user's posts every time they open their profile tab
    controller.fetchUserPosts();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'my_username',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        return CustomScrollView(
          slivers: [
            // 1. Profile Details Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        const Spacer(),
                        _buildStatColumn(controller.userPosts.length.toString(), "Posts"),
                        const Spacer(),
                        _buildStatColumn("142", "Followers"),
                        const Spacer(),
                        _buildStatColumn("218", "Following"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Flutter Developer",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Text("Building an Instagram clone with GetX & SQLite! 🚀"),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: Divider(height: 1, color: Colors.grey),
            ),

            // Grid Layout Icon Bar
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(icon: const Icon(Icons.grid_on), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.assignment_ind_outlined, color: Colors.grey), onPressed: () {}),
                ],
              ),
            ),

            // 2. 3-Column Post Photo Grid Layout
            controller.userPosts.isEmpty
                ? const SliverFillRemaining(
              child: Center(child: Text("No posts shared yet.")),
            )
                : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final post = controller.userPosts[index];
                  return Container(
                    color: Colors.grey[200],
                    child: post.imagePath.startsWith('assets/')
                        ? Image.asset(post.imagePath, fit: BoxFit.cover)
                        : Image.file(File(post.imagePath), fit: BoxFit.cover),
                  );
                },
                childCount: controller.userPosts.length,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

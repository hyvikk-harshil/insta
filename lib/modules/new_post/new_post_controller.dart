import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../data/models/post_model.dart';
import '../../../data/providers/db_provider.dart';
import '../feed/feed_controller.dart';

class NewPostController extends GetxController {
  final DbProvider _dbProvider = DbProvider();
  final ImagePicker _picker = ImagePicker();

  // Observable reactive variables
  var selectedImagePath = ''.obs;
  var isSaving = false.obs;

  // Text controller for the caption input
  final captionController = TextEditingController();

  // 1. Pick Image from Device Gallery
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  // 2. Save Image & Upload metadata into SQL
  Future<void> savePost() async {
    if (selectedImagePath.value.isEmpty) {
      Get.snackbar("Error", "Please select an image first");
      return;
    }

    try {
      isSaving(true);

      // Step A: Copy the image permanently to the local app document directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(selectedImagePath.value);
      final String savedLocalPath = p.join(appDir.path, fileName);

      // Execute file system copy
      await File(selectedImagePath.value).copy(savedLocalPath);

      // Step B: Create a PostModel instance
      final newPost = PostModel(
        userId: 1, // Current logged-in user from mock data
        imagePath: savedLocalPath, // Storing only the path string in database
        caption: captionController.text.trim(),
        timestamp: DateTime.now().toString(),
        username: 'my_username',
        userProfilePic: 'assets/mock/me.jpg',
      );

      // Step C: Write row records to SQLite
      await _dbProvider.insertPost(newPost);

      // Step D: Refresh the Home Feed instantly before navigating back
      if (Get.isRegistered<FeedController>()) {
        Get.find<FeedController>().fetchHomeFeed();
      }

      // Reset state and head back to feed
      Get.back();
      Get.snackbar("Success", "Post uploaded successfully!");
    } catch (e) {
      Get.snackbar("Database Error", "Failed to save post: $e");
    } finally {
      isSaving(false);
    }
  }

  @override
  void onClose() {
    captionController.dispose();
    super.onClose();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'new_post_controller.dart';

class NewPostView extends GetView<NewPostController> {
  const NewPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('New Post', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Obx(() => controller.isSaving.value
              ? const Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue))))
              : TextButton(
            onPressed: () => controller.savePost(),
            child: const Text('Share', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
          )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image Picker Canvas Selector
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Obx(() {
                  return Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: controller.selectedImagePath.value.isEmpty
                        ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Tap to select a photo from gallery", style: TextStyle(color: Colors.grey)),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(controller.selectedImagePath.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Caption Text Input Fields
              TextField(
                controller: controller.captionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

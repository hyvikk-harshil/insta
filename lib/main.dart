import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modules/feed/feed_binding.dart';
import 'modules/feed/feed_view.dart';
import 'modules/new_post/new_post_binding.dart';
import 'modules/new_post/new_post_view.dart';
import 'modules/profile/profile_binding.dart';
import 'modules/profile/profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/feed',
      getPages: [
        GetPage(
          name: '/feed',
          page: () => const FeedView(),
          binding: FeedBinding(), // Seamlessly injects the controller and dependencies
        ),
        // Add this inside the getPages list in lib/main.dart
        GetPage(
          name: '/new-post',
          page: () => const NewPostView(),
          binding: NewPostBinding(),
        ),
        // Add this inside the getPages list in lib/main.dart
        GetPage(
          name: '/profile',
          page: () => const ProfileView(),
          binding: ProfileBinding(),
        ),


      ],
    );
  }
}


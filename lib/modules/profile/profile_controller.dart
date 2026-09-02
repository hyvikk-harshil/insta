import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../data/providers/db_provider.dart';

class ProfileController extends GetxController {
  final DbProvider _dbProvider = DbProvider();

  var isLoading = true.obs;
  var userPosts = <PostModel>[].obs;

  final int currentUserId = 1;

  @override
  void onInit() {
    super.onInit();
    fetchUserPosts();
  }

  // Fetch only posts created by the current user from SQLite
  Future<void> fetchUserPosts() async {
    try {
      isLoading(true);

      // Get all posts from the feed
      var allPosts = await _dbProvider.getHomeFeed(currentUserId);

      // Filter out posts that belong to the current user
      var filteredPosts = allPosts.where((post) => post.userId == currentUserId).toList();

      userPosts.assignAll(filteredPosts);
    } catch (e) {
      Get.snackbar("Database Error", "Failed to load profile posts: $e");
    } finally {
      isLoading(false);
    }
  }
}

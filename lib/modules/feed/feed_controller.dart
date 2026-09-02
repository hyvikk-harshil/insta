import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/post_model.dart';
import '../../../data/providers/db_provider.dart';

class FeedController extends GetxController {
  // Instantiate your database query layer
  final DbProvider _dbProvider = DbProvider();

  // Observable state variables
  var isLoading = true.obs;
  var postList = <PostModel>[].obs;

  // Assuming logged-in user ID is 1 (corresponds to our SQL seed data)
  final int currentUserId = 1;

  @override
  void onInit() {
    super.onInit();
    fetchHomeFeed();
  }


  void sharePost(PostModel post) {
    // Using the new future-proof API structure
    SharePlus.instance.share(
      ShareParams(
        text: 'Check out this post by ${post.username} on Instagram Clone!\n\nCaption: "${post.caption}"\nImage: ${post.imagePath}',
        subject: 'Instagram Post Share',
      ),
    );
  }


  // 1. Fetch posts from local SQL Database
  Future<void> fetchHomeFeed() async {
    try {
      isLoading(true);
      // Fetching from SQLite
      var posts = await _dbProvider.getHomeFeed(currentUserId);

      // Assign the fresh data to our reactive list
      postList.assignAll(posts);
    } catch (e) {
      Get.snackbar("Database Error", "Failed to load Instagram feed: $e");
    } finally {
      isLoading(false);
    }
  }

  // 2. Handle Liking / Unliking posts reactively
  Future<void> toggleLikePost(int postId, int index) async {
    try {
      // Step A: Instant UI update (Optimistic UI update for a snappy feel)
      if (postList[index].isLiked == 1) {
        postList[index].isLiked = 0;
      } else {
        postList[index].isLiked = 1;
      }
      postList.refresh(); // Tells GetX to force refresh the UI instantly

      // Step B: Persist the change to your local SQL tables
      await _dbProvider.toggleLike(postId, currentUserId);
    } catch (e) {
      // Rollback UI update if SQL insert fails
      fetchHomeFeed();
      Get.snackbar("Error", "Could not save your like.");
    }
  }
}

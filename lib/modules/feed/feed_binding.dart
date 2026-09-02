import 'package:get/get.dart';
import 'feed_controller.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    // Injects the FeedController dependency lazily when needed
    Get.lazyPut<FeedController>(() => FeedController());
  }
}

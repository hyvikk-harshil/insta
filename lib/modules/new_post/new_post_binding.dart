import 'package:get/get.dart';
import 'new_post_controller.dart';

class NewPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewPostController>(() => NewPostController());
  }
}

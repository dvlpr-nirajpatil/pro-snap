import 'package:get/instance_manager.dart';
import 'package:prosnap/features/conversations/controllers/conversation_controller.dart';
import 'package:prosnap/features/home/controllers/home_controller.dart';
import 'package:prosnap/features/search/controllers/search_controller.dart';
import 'package:prosnap/features/story/controllers/story_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(StoryController());
    Get.put(SearchUsersController());
    Get.put(ConversationController());
  }
}

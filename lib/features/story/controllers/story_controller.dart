import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/models/story.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/features/story/repository/story_repository.dart';

class StoryController extends GetxController {
  final StoryRepository repository = StoryRepository();
  List<Story> stories = [];
  RxBool isLoading = false.obs;
  int page = 1;
  bool hasNext = true;
  bool loadingNext = false;
  final ScrollController scrollController = ScrollController();

  @override
  onInit() {
    super.onInit();
    getStories();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        loadNext();
      }
    });
  }

  getStories() async {
    isLoading.value = true;
    try {
      page = 1;
      stories.clear();
      Map response = await repository.getStories();
      List data = response['data']['stories'];
      stories = data.map((e) => Story.fromJson(e)).toList();
      page = response['data']['pagination']['page'];
      hasNext = response['data']['pagination']['hasNext'];
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar("Error !", e.message);
      }
      if (e is NoInternetException) {
        Get.snackbar("No Internet", e.message);
      }
      logger.e(e);
    } finally {
      isLoading.value = false;
    }
  }

  loadNext() async {
    if (loadingNext || hasNext == false) return;
    loadingNext = true;
    try {
      Map response = await repository.getStories(page: page + 1);
      List data = response['data']['stories'];
      stories.addAll(data.map((e) => Story.fromJson(e)).toList());
      page = response['data']['pagination']['page'];
      hasNext = response['data']['pagination']['hasNext'];
    } catch (e) {
      logger.e(e);
    }
    loadingNext = false;
    update(['story']);
  }
}

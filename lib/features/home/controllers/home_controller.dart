import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/models/post.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/features/home/repository/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository();
  List<Post> posts = [];
  RxBool isPostsLoading = false.obs;
  final ScrollController postsScrollController = ScrollController();

  int postPage = 1;
  bool morePostsAvailable = true;
  bool loadingNextPosts = false;

  @override
  onInit() {
    super.onInit();
    getInitialFeed();

    postsScrollController.addListener(() {
      if (postsScrollController.position.pixels >=
          postsScrollController.position.maxScrollExtent - 300) {
        loadNextPosts();
      }
    });
  }

  getInitialFeed() async {
    isPostsLoading.value = true;
    try {
      this.posts.clear();
      Map response = await repository.getFeed();
      final List posts = response['data']['posts'];

      this.posts = posts.map((e) => Post.fromJson(e)).toList();

      postPage = response['data']['pagination']['page'];
      morePostsAvailable = response['data']['pagination']['hasNext'];
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar("Error !", e.message);
      }
      if (e is NoInternetException) {
        Get.snackbar("No Internet", e.message);
      }
      logger.e(e);
    } finally {
      isPostsLoading.value = false;
    }
  }

  loadNextPosts() async {
    if (loadingNextPosts || morePostsAvailable == false) return;
    loadingNextPosts = true;
    try {
      Map response = await repository.getFeed(page: postPage + 1);
      final List posts = response['data']['posts'];
      this.posts.addAll(posts.map((e) => Post.fromJson(e)).toList());
      postPage = response['data']['pagination']['page'];
      morePostsAvailable = response['data']['pagination']['hasNext'];
    } catch (e) {
      if (e is ApiException) {
        logger.e(e.message);
      }
      if (e is NoInternetException) {
        Get.snackbar("No Internet", e.message);
      }
      logger.e(e);
    }
    loadingNextPosts = false;
    update(["posts"]);
  }
}

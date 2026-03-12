import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/models/post.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/features/search/models/search_user.dart';
import 'package:prosnap/features/search/repository/search_repository.dart';

class SearchUsersController extends GetxController {
  final SearchRepository repository = SearchRepository();

  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // SEARCH
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  RxList<SearchUser> searchResult = <SearchUser>[].obs;
  RxBool searchLoading = false.obs;
  RxString searchQuery = "".obs;

  searchUsers(q) async {
    searchResult.clear();
    searchLoading.value = true;
    try {
      final Map response = await repository.searchUsers(q);
      final List raw = response['data']['users'];
      searchResult.value = raw.map((e) => SearchUser.fromJson(e)).toList();
    } catch (e) {
      errorHandle(e);
    } finally {
      searchLoading.value = false;
    }
  }

  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // FEED
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  RxBool isLoading = false.obs;
  int currentFeedPage = 1;
  bool hasNextFeedPage = true;
  bool loadingNextFeedPage = false;
  RxList<Post> feedPosts = <Post>[].obs;
  final ScrollController searchFeedScrollController = ScrollController();

  @override
  onInit() {
    super.onInit();
    getInitialFeed();
    searchFeedScrollController.addListener(() {
      if (searchFeedScrollController.position.pixels >=
          searchFeedScrollController.position.maxScrollExtent - 300) {
        getNextFeedPage();
      }
    });

    debounce(searchQuery, (q) {
      if (q.trim() != "") {
        searchUsers(q);
      }
    }, time: Duration(milliseconds: 500));
  }

  getInitialFeed() async {
    isLoading.value = true;
    try {
      final Map response = await repository.getSearchFeed();

      // PAGINATION DETAILS
      currentFeedPage = response['data']['pagination']['page'];
      hasNextFeedPage = response['data']['pagination']['hasNext'];

      // FEED DETAILS
      List raw = response['data']['posts'];
      feedPosts.value = raw.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      errorHandle(e);
    } finally {
      isLoading.value = false;
    }
  }

  getNextFeedPage() async {
    if (loadingNextFeedPage || hasNextFeedPage == false) return;
    loadingNextFeedPage = true;

    try {
      final Map response = await repository.getSearchFeed(
        page: currentFeedPage + 1,
      );

      // PAGINATION DETAILS
      currentFeedPage = response['data']['pagination']['page'];
      hasNextFeedPage = response['data']['pagination']['hasNext'];

      // FEED DETAILS
      List raw = response['data']['posts'];
      feedPosts.addAll(raw.map((e) => Post.fromJson(e)).toList());
    } catch (e) {
      errorHandle(e);
    } finally {
      loadingNextFeedPage = false;
    }
  }
}

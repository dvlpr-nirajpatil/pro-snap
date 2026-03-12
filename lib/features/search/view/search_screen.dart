import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/profile_details/views/profile_details_screen.dart';
import 'package:prosnap/features/search/controllers/search_controller.dart';
import 'package:prosnap/features/search/models/search_user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isSearching = false;
  final SearchUsersController controller = Get.find<SearchUsersController>();

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Column(
          children: [
            verticalSpace(15),

            /// Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colours.white, width: 0.6),
                ),
                child: TextField(
                  controller: _controller,
                  cursorColor: Colours.white,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Search people, posts, #hashtags",
                    hintStyle: TextStyle(
                      fontFamily: Fonts.light,
                      color: Colours.grey,
                      fontSize: 13.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colours.white.withOpacity(0.8),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            verticalSpace(20),

            /// Body
            Obx(
              () => Expanded(
                child:
                    controller.searchQuery.value != ""
                        ? _buildSearchResults()
                        : _buildExploreGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- EXPLORE GRID ----------------
  Widget _buildExploreGrid() {
    return GridView.builder(
      controller: controller.searchFeedScrollController,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
      ),
      itemCount: controller.feedPosts.length,
      itemBuilder: (context, index) {
        return Container(
          child: Image.network(
            controller.feedPosts[index].media!.first.url!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  /// ---------------- SEARCH RESULTS ----------------
  Widget _buildSearchResults() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        _sectionTitle("People"),
        verticalSpace(10),
        ...List.generate(
          controller.searchResult.length,
          (index) => _buildUserResult(controller.searchResult[index]),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: Fonts.semiBold,
        fontSize: 14.sp,
        color: Colours.white,
      ),
    );
  }

  Widget _buildUserResult(SearchUser user) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProfileDetailsScreen(userId: user.id!));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: Colours.divider,
              child:
                  user.profilePicture == null
                      ? Text(user.name?[0].toUpperCase() ?? "U")
                      : CachedNetworkImage(
                        imageUrl: user.profilePicture,
                        fit: BoxFit.cover,
                      ),
            ),
            horizontalSpace(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName!,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                ),
                Text(
                  user.name!,
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 12.sp,
                    color: Colours.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHashtagResult(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        "#minimal_$index",
        style: TextStyle(
          fontFamily: Fonts.medium,
          fontSize: 14.sp,
          color: Colours.white,
        ),
      ),
    );
  }
}

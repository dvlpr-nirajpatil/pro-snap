import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/models/post.dart';
import 'package:prosnap/features/home/components/story_shimmer.dart';
import 'package:prosnap/features/home/controllers/home_controller.dart';
import 'package:prosnap/features/home/views/post_widget.dart';
import 'package:prosnap/features/story/controllers/story_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends GetWidget<HomeController> {
  HomeScreen({super.key});

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getInitialFeed();
            Get.find<StoryController>().getStories();
          },
          child: CustomScrollView(
            controller: controller.postsScrollController,
            slivers: [
              /// Top App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  child: Text(
                    "PRO SNAP",
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 22.sp,
                      letterSpacing: 4,
                      color: Colours.white,
                    ),
                  ),
                ),
              ),

              /// Stories Section
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100.h,
                  child: GetBuilder<StoryController>(
                    id: "story",
                    builder:
                        (controller) => Obx(
                          () =>
                              controller.isLoading.value
                                  ? const StoriesShimmer()
                                  : ListView.builder(
                                    controller: controller.scrollController,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    itemCount: controller.stories.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 16.w),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 65.h,
                                              width: 65.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colours.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colours.divider,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                      controller
                                                          .stories[index]
                                                          .stories!
                                                          .first
                                                          .media!
                                                          .url!,
                                                    ),
                                              ),
                                            ),
                                            verticalSpace(8),
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                controller
                                                    .stories[index]
                                                    .user!
                                                    .userName!,
                                                style: TextStyle(
                                                  fontFamily: Fonts.light,
                                                  fontSize: 11.sp,
                                                  color: Colours.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                        ),
                  ),
                ),
              ),

              /// Thin Divider
              SliverToBoxAdapter(
                child: Divider(color: Colours.divider, thickness: 0.5),
              ),

              /// Posts
              GetBuilder<HomeController>(
                id: "posts",
                builder:
                    (controller) => Obx(
                      () =>
                          controller.isPostsLoading.value
                              ? SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return const _PostShimmer();
                                }, childCount: 5),
                              )
                              : SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return PostWidget(
                                    post: controller.posts[index],
                                  );
                                }, childCount: controller.posts.length),
                              ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostShimmer extends StatelessWidget {
  const _PostShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Shimmer.fromColors(
        baseColor: Colours.divider,
        highlightColor: Colours.white.withOpacity(0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  CircleAvatar(radius: 18.r, backgroundColor: Colours.divider),
                  SizedBox(width: 12.w),
                  Container(width: 120.w, height: 12.h, color: Colours.divider),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            /// Image
            Container(
              height: 380.h,
              width: double.infinity,
              color: Colours.divider,
            ),

            SizedBox(height: 15.h),

            /// Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Container(width: 22.w, height: 22.w, color: Colours.divider),
                  SizedBox(width: 20.w),
                  Container(width: 22.w, height: 22.w, color: Colours.divider),
                  const Spacer(),
                  Container(width: 22.w, height: 22.w, color: Colours.divider),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            Divider(color: Colours.divider, thickness: 0.5),
          ],
        ),
      ),
    );
  }
}

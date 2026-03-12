import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/auth/views/sign_up_screen.dart';
import 'package:prosnap/features/conversations/controllers/conversation_controller.dart';
import 'package:prosnap/features/profile_details/controllers/profile_details_controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final String userId;
  const ProfileDetailsScreen({super.key, required this.userId});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  Widget verticalSpace(double h) => SizedBox(height: h.h);

  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  late final ProfileDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileDetailsController());
    controller.getProfileDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: Obx(
        () => CustomScrollView(
          slivers:
              controller.isLoading.value
                  ? _buildShimmerSlivers()
                  : _buildContentSlivers(),
        ),
      ),
    );
  }

  List<Widget> _buildContentSlivers() {
    return [
      /// APP BAR
      SliverAppBar(
        backgroundColor: Colours.primary,
        elevation: 0,
        pinned: true,
        centerTitle: true,
        title: Text(
          controller.details.value!.userName!,
          style: TextStyle(
            fontFamily: Fonts.semiBold,
            fontSize: 16.sp,
            color: Colours.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.more_vert, color: Colours.white),
          ),
        ],
      ),

      /// PROFILE HEADER
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(20),

              /// PROFILE IMAGE + STATS
              Row(
                children: [
                  CircleAvatar(radius: 40.r, backgroundColor: Colours.divider),

                  const Spacer(),

                  _buildStat(
                    "${controller.details.value?.counts?.posts}",
                    "Posts",
                  ),
                  horizontalSpace(20),
                  _buildStat(
                    "${controller.details.value?.counts?.followers}",
                    "Followers",
                  ),
                  horizontalSpace(20),
                  _buildStat(
                    "${controller.details.value?.counts?.following}",
                    "Following",
                  ),
                ],
              ),

              verticalSpace(16),

              /// NAME
              Text(
                "${controller.details.value?.name}",
                style: TextStyle(
                  fontFamily: Fonts.semiBold,
                  fontSize: 14.sp,
                  color: Colours.white,
                ),
              ),

              verticalSpace(4),

              /// BIO
              Text(
                "${controller.details.value!.bio}",
                style: TextStyle(
                  fontFamily: Fonts.light,
                  fontSize: 12.sp,
                  color: Colours.grey,
                ),
              ),

              verticalSpace(16),

              /// EDIT PROFILE BUTTON
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final ConversationController convoController =
                      Get.find<ConversationController>();
                  return OutlinedButton(
                    onPressed:
                        convoController.isLoading.value
                            ? null
                            : () {
                              convoController.createConversation(
                                userId: controller.details.value!.id!,
                              );
                            },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colours.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        convoController.isLoading.value
                            ? ButtonLoader()
                            : Text(
                              "Send Message",
                              style: TextStyle(
                                fontFamily: Fonts.medium,
                                color: Colours.white,
                                fontSize: 13.sp,
                              ),
                            ),
                  );
                }),
              ),

              verticalSpace(24),

              /// STORY HIGHLIGHTS
              SizedBox(
                height: 90.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Column(
                        children: [
                          Container(
                            height: 60.h,
                            width: 60.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colours.white,
                                width: 1,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colours.divider,
                            ),
                          ),
                          verticalSpace(6),
                          Text(
                            "Highlight",
                            style: TextStyle(
                              fontFamily: Fonts.light,
                              fontSize: 11.sp,
                              color: Colours.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              verticalSpace(20),
            ],
          ),
        ),
      ),

      /// POST GRID
      SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Container(color: Colours.divider);
        }, childCount: 30),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 2.w,
        ),
      ),
    ];
  }

  List<Widget> _buildShimmerSlivers() {
    return [
      SliverAppBar(
        backgroundColor: Colours.primary,
        elevation: 0,
        pinned: true,
        centerTitle: true,
        title: _shimmerBox(width: 100.w, height: 14.h),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: _shimmerBox(width: 20.w, height: 20.w, radius: 20.r),
          ),
        ],
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Shimmer.fromColors(
            baseColor: Colours.divider,
            highlightColor: Colours.white.withValues(alpha: 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(20),
                Row(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: const BoxDecoration(
                        color: Colours.divider,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Spacer(),
                    _buildShimmerStat(),
                    horizontalSpace(20),
                    _buildShimmerStat(),
                    horizontalSpace(20),
                    _buildShimmerStat(),
                  ],
                ),
                verticalSpace(16),
                _shimmerBox(width: 120.w, height: 14.h),
                verticalSpace(8),
                _shimmerBox(width: double.infinity, height: 10.h),
                verticalSpace(6),
                _shimmerBox(width: 200.w, height: 10.h),
                verticalSpace(16),
                _shimmerBox(width: double.infinity, height: 36.h, radius: 8.r),
                verticalSpace(24),
                SizedBox(
                  height: 90.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (_, __) => horizontalSpace(16),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: const BoxDecoration(
                              color: Colours.divider,
                              shape: BoxShape.circle,
                            ),
                          ),
                          verticalSpace(6),
                          _shimmerBox(width: 52.w, height: 10.h),
                        ],
                      );
                    },
                  ),
                ),
                verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
      SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Shimmer.fromColors(
            baseColor: Colours.divider,
            highlightColor: Colours.white.withValues(alpha: 0.08),
            child: Container(color: Colours.divider),
          );
        }, childCount: 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 2.w,
        ),
      ),
    ];
  }

  Widget _buildShimmerStat() {
    return Column(
      children: [
        _shimmerBox(width: 34.w, height: 14.h),
        verticalSpace(6),
        _shimmerBox(width: 52.w, height: 10.h),
      ],
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Shimmer.fromColors(
      baseColor: Colours.divider,
      highlightColor: Colours.white.withValues(alpha: 0.08),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colours.divider,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontFamily: Fonts.semiBold,
            fontSize: 15.sp,
            color: Colours.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.light,
            fontSize: 11.sp,
            color: Colours.grey,
          ),
        ),
      ],
    );
  }
}

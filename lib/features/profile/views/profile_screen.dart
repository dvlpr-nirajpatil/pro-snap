import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/features/auth/controllers/auth_controller.dart';
import 'package:prosnap/features/manage_profile/views/manage_profile_screen.dart';
import 'package:prosnap/features/profile/views/verified_subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = CurrentUser();
    final displayName = user.name.isNotEmpty ? user.name : "Pro User";
    final userName = user.userName.isNotEmpty ? user.userName : "pro_user";
    final bio =
        user.bio.isNotEmpty
            ? user.bio
            : "Capturing minimal moments in silence.\nLuxury • Editorial • Black & White";

    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colours.primary,
              elevation: 0,
              titleSpacing: 20.w,
              title: Text(
                "@$userName",
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 18.sp,
                  color: Colours.white,
                ),
              ),
              actions: [
                Obx(
                  () => IconButton(
                    tooltip: "Sign out",
                    onPressed:
                        authController.signUpLoading.value
                            ? null
                            : authController.signOut,
                    icon:
                        authController.signUpLoading.value
                            ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colours.white,
                              ),
                            )
                            : Icon(
                              Icons.logout_rounded,
                              color: Colours.white,
                              size: 20.sp,
                            ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileHeader(
                      name: displayName,
                      userName: userName,
                      bio: bio,
                      imageUrl: user.profilePicture,
                      isVerified: user.isVerified,
                    ),
                    verticalSpace(22),
                    Row(
                      children: [
                        Expanded(child: _buildStat("120", "Posts")),
                        horizontalSpace(10),
                        Expanded(child: _buildStat("5.2K", "Followers")),
                        horizontalSpace(10),
                        Expanded(child: _buildStat("380", "Following")),
                      ],
                    ),
                    verticalSpace(18),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.edit_outlined,
                            label: "Manage",
                            onTap: () => Get.to(() => ManageProfileScreen()),
                          ),
                        ),
                        horizontalSpace(10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.verified_outlined,
                            label: "Verify",
                            onTap:
                                () => Get.to(
                                  () => const VerifiedSubscriptionScreen(),
                                ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(18),
                    _buildVerifiedCard(),
                    verticalSpace(24),
                    _ProfileTabs(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _PostTile(index: index),
                  childCount: 18,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.w,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colours.divider,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colours.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontFamily: Fonts.bold,
              fontSize: 17.sp,
              color: Colours.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: Fonts.light,
              fontSize: 11.sp,
              color: Colours.white.withValues(alpha: 0.68),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedCard() {
    return Material(
      color: Colours.white,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: () => Get.to(() => const VerifiedSubscriptionScreen()),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                height: 46.h,
                width: 46.h,
                decoration: BoxDecoration(
                  color: Colours.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.verified_rounded,
                  color: Colours.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Build a trusted profile",
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        fontSize: 14.sp,
                        color: Colours.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Unlock verification, profile priority, and account support.",
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 11.sp,
                        color: Colours.primary.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colours.primary,
                size: 15.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String userName;
  final String bio;
  final String imageUrl;
  final bool isVerified;

  const _ProfileHeader({
    required this.name,
    required this.userName,
    required this.bio,
    required this.imageUrl,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 92.w,
              height: 92.w,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colours.white, width: 1),
              ),
              child: CircleAvatar(
                backgroundColor: Colours.divider,
                backgroundImage:
                    imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                child:
                    imageUrl.isEmpty
                        ? Text(
                          name.characters.first.toUpperCase(),
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 30.sp,
                            color: Colours.white,
                          ),
                        )
                        : null,
              ),
            ),
            if (isVerified)
              Positioned(
                right: 2.w,
                bottom: 6.h,
                child: Container(
                  height: 24.h,
                  width: 24.h,
                  decoration: const BoxDecoration(
                    color: Colours.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    color: Colours.primary,
                    size: 18.sp,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 18.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: Fonts.bold,
                          fontSize: 22.sp,
                          color: Colours.white,
                        ),
                      ),
                    ),
                    if (isVerified) ...[
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.verified_rounded,
                        color: Colours.white,
                        size: 18.sp,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  "@$userName",
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 12.sp,
                    color: Colours.grey,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  bio,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 12.sp,
                    height: 1.35,
                    color: Colours.white.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17.sp),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colours.white,
          side: BorderSide(color: Colours.white.withValues(alpha: 0.24)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(fontFamily: Fonts.semiBold, fontSize: 12.sp),
        ),
      ),
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colours.white.withValues(alpha: 0.08)),
          bottom: BorderSide(color: Colours.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _tab(Icons.grid_on_rounded, true)),
          Expanded(child: _tab(Icons.bookmark_border_rounded, false)),
          Expanded(child: _tab(Icons.person_pin_outlined, false)),
        ],
      ),
    );
  }

  Widget _tab(IconData icon, bool selected) {
    return Center(
      child: Icon(
        icon,
        color: selected ? Colours.white : Colours.grey,
        size: 21.sp,
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  final int index;

  const _PostTile({required this.index});

  @override
  Widget build(BuildContext context) {
    final shades = [
      const Color(0xFF242424),
      const Color(0xFF303030),
      const Color(0xFF181818),
      const Color(0xFF3A3A3A),
    ];

    return Container(
      color: shades[index % shades.length],
      child: Stack(
        children: [
          Positioned(
            right: 8.w,
            top: 8.h,
            child: Icon(
              index.isEven
                  ? Icons.collections_rounded
                  : Icons.play_arrow_rounded,
              color: Colours.white.withValues(alpha: 0.72),
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

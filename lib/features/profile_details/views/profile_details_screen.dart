import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key, required this.userId});

  final String userId;

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colours.primary,
            elevation: 0,
            pinned: true,
            centerTitle: true,
            title: Text(
              'profile_$userId',
              style: TextStyle(
                fontFamily: Fonts.semiBold,
                fontSize: 16.sp,
                color: Colours.white,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: const Icon(Icons.more_vert, color: Colours.white),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(20),
                  Row(
                    children: [
                      CircleAvatar(radius: 40.r, backgroundColor: Colours.divider),
                      const Spacer(),
                      _buildStat('0', 'Posts'),
                      horizontalSpace(20),
                      _buildStat('0', 'Followers'),
                      horizontalSpace(20),
                      _buildStat('0', 'Following'),
                    ],
                  ),
                  verticalSpace(16),
                  Text(
                    'Static Profile',
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 14.sp,
                      color: Colours.white,
                    ),
                  ),
                  verticalSpace(4),
                  Text(
                    'Controller-backed profile data has been removed and replaced with a static placeholder.',
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 12.sp,
                      color: Colours.grey,
                    ),
                  ),
                  verticalSpace(16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colours.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Send Message',
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          color: Colours.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(24),
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
                                child: const CircleAvatar(
                                  backgroundColor: Colours.divider,
                                ),
                              ),
                              verticalSpace(6),
                              Text(
                                'Highlight',
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
        ],
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
            fontSize: 14.sp,
            color: Colours.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.light,
            fontSize: 11.sp,
            color: Colours.white,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:shimmer/shimmer.dart';

class StoriesShimmer extends StatelessWidget {
  const StoriesShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Shimmer.fromColors(
              baseColor: Colours.divider,
              highlightColor: Colours.white.withOpacity(0.08),
              child: Column(
                children: [
                  Container(
                    height: 65.h,
                    width: 65.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colours.divider,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(width: 50.w, height: 10.h, color: Colours.divider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

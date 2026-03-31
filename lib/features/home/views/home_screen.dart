import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController postsScrollController = ScrollController();
  final ScrollController storiesScrollController = ScrollController();
  final List<String> stories = ['Alex', 'Riya', 'Sam'];

  Widget verticalSpace(double h) => SizedBox(height: h.h);

  Future<void> _refresh() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: postsScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: Text(
                    'PRO SNAP',
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 22.sp,
                      letterSpacing: 4,
                      color: Colours.white,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    controller: storiesScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: stories.length,
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
                              child: const CircleAvatar(
                                backgroundColor: Colours.divider,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colours.white,
                                ),
                              ),
                            ),
                            verticalSpace(8),
                            SizedBox(
                              width: 80,
                              child: Text(
                                stories[index],
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
              const SliverToBoxAdapter(
                child: Divider(color: Colours.divider, thickness: 0.5),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      'Feed state has been detached from the old controller layer. Static placeholders are in place until Bloc is wired up.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Fonts.light,
                        fontSize: 14.sp,
                        color: Colours.white.withOpacity(0.7),
                      ),
                    ),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/home/cubits/posts_cubit/posts_cubit.dart';
import 'package:prosnap/features/home/cubits/stories_cubit/stories_cubit.dart';
import 'package:prosnap/features/home/views/post_widget.dart';
import 'package:shimmer/shimmer.dart';

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

  Future<void> _refresh() async {
    postsCubit.getInitialPosts();
  }

  late final PostsCubit postsCubit;
  late final StoriesCubit storyCubit;

  @override
  void initState() {
    postsCubit = context.read<PostsCubit>();
    storyCubit = context.read<StoriesCubit>();
    postsCubit.getInitialPosts();
    storyCubit.getInitialStories();

    postsScrollController.addListener(() {
      if (postsScrollController.position.pixels >=
          postsScrollController.position.maxScrollExtent - 500) {
        postsCubit.getNextPosts();
      }
    });
    storiesScrollController.addListener(() {
      if (storiesScrollController.position.pixels >=
          storiesScrollController.position.maxScrollExtent - 50) {
        storyCubit.getNextStories();
      }
    });
  }

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
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
                  child: BlocBuilder<StoriesCubit, StoriesState>(
                    builder: (c, state) {
                      if (state is GetStoriesLoadingState) {
                        return ListView.builder(
                          itemCount: 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => StoriesShimmer(),
                        );
                      }

                      if (state is GetStoriesSuccessState) {
                        return ListView.builder(
                          controller: storiesScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: storyCubit.stories.length,
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
                                      backgroundColor: Colours.divider,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                            storyCubit
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
                                      storyCubit.stories[index].user!.userName!,
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
                        );
                      }

                      return SizedBox();
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Divider(color: Colours.divider, thickness: 0.5),
              ),
              BlocBuilder<PostsCubit, PostsState>(
                builder: (context, state) {
                  if (state is GetPostsLoadingState) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return const _PostShimmer();
                      }, childCount: 5),
                    );
                  }

                  if (state is GetPostsSuccessState) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return PostWidget(post: postsCubit.posts[index]);
                      }, childCount: postsCubit.posts.length),
                    );
                  }

                  if (state is GetPostsErrorState) {
                    return Center(child: Text(state.error));
                  }

                  return SizedBox();
                },
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/models/post.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  bool isSaved = false;
  bool showHeart = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween(
      begin: 0.5,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      showHeart = true;
    });

    _controller.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => showHeart = false);
    });
  }

  void toggleSave() {
    setState(() => isSaved = !isSaved);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: CachedNetworkImageProvider(
                  post.userId!.profilePicture!,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.userId!.userName!,
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 13.sp,
                      color: Colours.white,
                    ),
                  ),
                  Text(
                    post.location ?? "",
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 11.sp,
                      color: Colours.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colours.white, size: 20.sp),
            ],
          ),
        ),

        SizedBox(height: 15.h),

        /// IMAGE + DOUBLE TAP
        GestureDetector(
          onDoubleTap: toggleLike,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 380.h,
                width: double.infinity,
                child: PageView(
                  children: List.generate(
                    post.media!.length,
                    (index) => CachedNetworkImage(
                      imageUrl: post.media![index].url!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              /// HEART ANIMATION
              if (showHeart)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    Icons.favorite,
                    size: 90.sp,
                    color: Colours.white.withOpacity(0.9),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 15.h),

        /// ACTIONS
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: toggleLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colours.white : Colours.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () => _openComments(context),
                child: Icon(
                  Icons.mode_comment_outlined,
                  color: Colours.white,
                  size: 22.sp,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: toggleSave,
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colours.white,
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        /// LIKE COUNT
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () => _openLikesSheet(context),
            child: Text(
              "${post.likesCount ?? 0} likes",
              style: TextStyle(
                fontFamily: Fonts.semiBold,
                fontSize: 13.sp,
                color: Colours.white,
              ),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () => _openComments(context),
            child: Text(
              "View all ${post.commentsCount ?? 0} comments",
              style: TextStyle(
                fontFamily: Fonts.light,
                fontSize: 12.sp,
                color: Colours.grey,
              ),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        /// CAPTION
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${post.userId?.userName} ",
                  style: TextStyle(
                    fontFamily: Fonts.semiBold,
                    fontSize: 13.sp,
                    color: Colours.white,
                  ),
                ),
                TextSpan(
                  text: post.caption ?? "",
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 13.sp,
                    color: Colours.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20.h),
        Divider(color: Colours.divider, thickness: 0.5),
      ],
    );
  }

  /// ---------------- COMMENT SHEET ----------------
  void _openComments(BuildContext context) {
    String? replyingTo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colours.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  children: [
                    SizedBox(height: 12.h),

                    /// Drag Indicator
                    Container(
                      width: 45.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colours.divider,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// Title
                    Text(
                      "Comments",
                      style: TextStyle(
                        fontFamily: Fonts.semiBold,
                        fontSize: 15.sp,
                        color: Colours.white,
                        letterSpacing: 1,
                      ),
                    ),

                    SizedBox(height: 15.h),
                    Divider(color: Colours.divider, thickness: 0.5),

                    /// COMMENTS LIST
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: 10,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16.r,
                                      backgroundColor: Colours.divider,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "user_$index ",
                                                  style: TextStyle(
                                                    fontFamily: Fonts.semiBold,
                                                    fontSize: 13.sp,
                                                    color: Colours.white,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "Beautiful capture!",
                                                  style: TextStyle(
                                                    fontFamily: Fonts.light,
                                                    fontSize: 13.sp,
                                                    color: Colours.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 6.h),

                                          GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                replyingTo = "user_$index";
                                              });
                                            },
                                            child: Text(
                                              "Reply",
                                              style: TextStyle(
                                                fontFamily: Fonts.light,
                                                fontSize: 11.sp,
                                                color: Colours.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    Divider(color: Colours.divider),

                    /// INPUT SECTION
                    Container(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 10.h,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          /// Replying To Indicator
                          if (replyingTo != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              margin: EdgeInsets.only(bottom: 8.h),
                              decoration: BoxDecoration(
                                color: Colours.divider,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Replying to $replyingTo",
                                      style: TextStyle(
                                        fontFamily: Fonts.light,
                                        fontSize: 11.sp,
                                        color: Colours.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        replyingTo = null;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 14.sp,
                                      color: Colours.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colours.white,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: TextField(
                                    cursorColor: Colours.white,
                                    style: TextStyle(
                                      fontFamily: Fonts.medium,
                                      fontSize: 13.sp,
                                      color: Colours.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Add a comment...",
                                      hintStyle: TextStyle(
                                        fontFamily: Fonts.light,
                                        color: Colours.grey,
                                      ),
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 12.w),

                              GestureDetector(
                                onTap: () {
                                  // submit comment
                                },
                                child: Text(
                                  "Post",
                                  style: TextStyle(
                                    fontFamily: Fonts.semiBold,
                                    fontSize: 14.sp,
                                    color: Colours.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    30.verticalSpace,
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _openLikesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colours.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                SizedBox(height: 12.h),

                /// Drag Handle
                Container(
                  width: 45.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colours.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                SizedBox(height: 20.h),

                Text(
                  "Liked By",
                  style: TextStyle(
                    fontFamily: Fonts.semiBold,
                    fontSize: 15.sp,
                    color: Colours.white,
                    letterSpacing: 1,
                  ),
                ),

                SizedBox(height: 15.h),
                Divider(color: Colours.divider),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 15, // replace with real likes list
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colours.divider,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                "user_$index",
                                style: TextStyle(
                                  fontFamily: Fonts.medium,
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                ),
                              ),
                            ),
                            Text(
                              "Follow",
                              style: TextStyle(
                                fontFamily: Fonts.semiBold,
                                fontSize: 12.sp,
                                color: Colours.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/chating/views/chating_screen.dart';
import 'package:prosnap/features/conversations/controllers/conversation_controller.dart';
import 'package:prosnap/features/conversations/models/conversation_model.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConversationController>();
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Column(
          children: [
            verticalSpace(20),

            /// Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Messages",
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 22.sp,
                    letterSpacing: 2,
                    color: Colours.white,
                  ),
                ),
              ),
            ),

            verticalSpace(20),

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
                  cursorColor: Colours.white,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search conversations",
                    hintStyle: TextStyle(
                      fontFamily: Fonts.light,
                      color: Colours.grey,
                      fontSize: 13.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colours.white.withOpacity(0.8),
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            verticalSpace(20),

            /// Chat List
            Expanded(
              child: Obx(() {
                final List<ConversationModel> conversations =
                    controller.conversations;
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: conversations.length,
                  separatorBuilder:
                      (_, __) =>
                          Divider(color: Colours.divider, thickness: 0.5),
                  itemBuilder: (context, index) {
                    return _buildChatTile(conversations[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile(ConversationModel conversation) {
    final profilePicture = conversation.opponent?.profilePicture;
    final name = conversation.opponent?.name;
    return InkWell(
      onTap: () {
        Get.to(() => ChatingScreen(), arguments: conversation.id);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            /// Profile Image
            CircleAvatar(
              radius: 26.r,
              backgroundColor: Colours.divider,
              backgroundImage:
                  profilePicture != null ? NetworkImage(profilePicture) : null,
              child:
                  profilePicture == null
                      ? Text(name?[0].toUpperCase() ?? "N")
                      : null,
            ),

            horizontalSpace(14),

            /// Name + Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.opponent?.name ?? "No Name",
                    style: TextStyle(
                      fontFamily: Fonts.semiBold,
                      fontSize: 14.sp,
                      color: Colours.white,
                    ),
                  ),
                  verticalSpace(6),
                  Text(
                    conversation.lastMessage?.text ?? "No Message",
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 12.sp,
                      color: Colours.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            /// Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "2:45 PM",
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 11.sp,
                    color: Colours.white.withOpacity(0.6),
                    letterSpacing: 1,
                  ),
                ),
                verticalSpace(6),

                /// Unread Dot (optional)
                Container(
                  height: 6.h,
                  width: 6.h,
                  decoration: const BoxDecoration(
                    color: Colours.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

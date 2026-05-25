import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:get/instance_manager.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/features/chating/controllers/chat_controller.dart';
import 'package:prosnap/features/chating/models/message_model.dart';

class ChatingScreen extends StatelessWidget {
  const ChatingScreen({super.key});

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 TOP BAR
            _buildTopBar(context),

            /// Divider
            Divider(color: Colours.divider, thickness: 0.5),

            /// 💬 Messages
            Expanded(
              child: Obx(() {
                final List<MessageModel> messages = controller.messages;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _MessageBubble(
                      message: message.text ?? "",
                      isMe: message.sender == CurrentUser().id,
                    );
                  },
                );
              }),
            ),

            /// ✍ Input Area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  /// ---------------- TOP BAR ----------------
  Widget _buildTopBar(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          /// Back
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18.sp,
              color: Colours.white,
            ),
          ),

          horizontalSpace(12),

          /// Avatar
          Obx(() {
            final profilePicture =
                controller.chatDetails.value?.opponent?.profilePicture;
            final String? name = controller.chatDetails.value?.opponent?.name;
            return CircleAvatar(
              radius: 20.r,
              backgroundColor: Colours.divider,
              backgroundImage:
                  profilePicture != null ? NetworkImage(profilePicture) : null,
              child:
                  profilePicture == null
                      ? Text(name?[0].toUpperCase() ?? "S")
                      : null,
            );
          }),

          horizontalSpace(12),

          /// Name + Status
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller
                          .chatDetails
                          .value
                          ?.opponent
                          ?.name
                          ?.capitalizeFirst ??
                      "No Name",
                  style: TextStyle(
                    fontFamily: Fonts.semiBold,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 11.sp,
                    color: Colours.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          /// Options
          PopupMenuButton<String>(
            color: Colours.primary,
            icon: Icon(Icons.more_vert, color: Colours.white, size: 20.sp),
            onSelected: (value) {},
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: "report",
                    child: Text(
                      "Report",
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        color: Colours.white,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: "block",
                    child: Text(
                      "Block",
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        color: Colours.white,
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  /// ---------------- INPUT AREA ----------------
  Widget _buildInputArea() {
    final controller = Get.find<ChatController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colours.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          /// Attachment
          Icon(
            Icons.attach_file,
            color: Colours.white.withValues(alpha: 0.7),
            size: 22.sp,
          ),

          horizontalSpace(10),

          /// Text Field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colours.white, width: 0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller.messageController,
                onSubmitted: (_) => controller.sendMessage(),
                cursorColor: Colours.white,
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 13.sp,
                  color: Colours.white,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message...",
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

          horizontalSpace(10),

          /// Send
          Obx(
            () => GestureDetector(
              onTap: controller.isSending.value ? null : controller.sendMessage,
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color:
                      controller.isSending.value
                          ? Colours.white.withValues(alpha: 0.7)
                          : Colours.white,
                  shape: BoxShape.circle,
                ),
                child:
                    controller.isSending.value
                        ? Padding(
                          padding: EdgeInsets.all(10.w),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colours.primary,
                            ),
                          ),
                        )
                        : Icon(
                          Icons.arrow_upward,
                          size: 18.sp,
                          color: Colours.primary,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- MESSAGE BUBBLE ----------------
class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            constraints: BoxConstraints(maxWidth: 250.w),
            decoration: BoxDecoration(
              color: isMe ? Colours.white : Colours.divider,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
                bottomRight: Radius.circular(isMe ? 4.r : 18.r),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 13.sp,
                color: isMe ? Colours.primary : Colours.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

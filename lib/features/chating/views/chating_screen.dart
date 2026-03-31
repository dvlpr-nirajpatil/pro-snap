import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/features/chating/models/message_model.dart';

class ChatingScreen extends StatefulWidget {
  const ChatingScreen({super.key, this.conversationId});

  final String? conversationId;

  @override
  State<ChatingScreen> createState() => _ChatingScreenState();
}

class _ChatingScreenState extends State<ChatingScreen> {
  final TextEditingController messageController = TextEditingController();
  final List<MessageModel> messages = [];
  bool isSending = false;
  String opponentName = 'No Name';
  String? profilePicture;

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  void _sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      messages.insert(
        0,
        MessageModel(
          text: messageController.text.trim(),
          sender: CurrentUser().id,
          conversation: widget.conversationId,
        ),
      );
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const Divider(color: Colours.divider, thickness: 0.5),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                itemBuilder: (context, index) => _MessageBubble(
                  message: messages[index].text ?? '',
                  isMe: messages[index].sender == CurrentUser().id,
                ),
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18.sp,
              color: Colours.white,
            ),
          ),
          horizontalSpace(12),
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colours.divider,
            backgroundImage:
                profilePicture != null ? NetworkImage(profilePicture!) : null,
            child: profilePicture == null ? Text(opponentName[0]) : null,
          ),
          horizontalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opponentName,
                style: TextStyle(
                  fontFamily: Fonts.semiBold,
                  fontSize: 14.sp,
                  color: Colours.white,
                ),
              ),
              Text(
                'Offline',
                style: TextStyle(
                  fontFamily: Fonts.light,
                  fontSize: 11.sp,
                  color: Colours.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton<String>(
            color: Colours.primary,
            icon: Icon(Icons.more_vert, color: Colours.white, size: 20.sp),
            onSelected: (value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Text(
                  'Report',
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    color: Colours.white,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'block',
                child: Text(
                  'Block',
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

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colours.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.attach_file,
            color: Colours.white.withValues(alpha: 0.7),
            size: 22.sp,
          ),
          horizontalSpace(10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colours.white, width: 0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: messageController,
                onSubmitted: (_) => _sendMessage(),
                cursorColor: Colours.white,
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 13.sp,
                  color: Colours.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
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
          GestureDetector(
            onTap: isSending ? null : _sendMessage,
            child: Container(
              height: 40.h,
              width: 40.h,
              decoration: BoxDecoration(
                color: isSending
                    ? Colours.white.withValues(alpha: 0.7)
                    : Colours.white,
                shape: BoxShape.circle,
              ),
              child: isSending
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
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        constraints: BoxConstraints(maxWidth: 250.w),
        decoration: BoxDecoration(
          color: isMe ? Colours.white : Colours.divider,
          borderRadius: BorderRadius.circular(18),
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
    );
  }
}

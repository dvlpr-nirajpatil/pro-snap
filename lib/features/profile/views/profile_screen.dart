import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/features/auth/controllers/auth_controller.dart';
import 'package:prosnap/features/auth/views/sign_up_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            CircleAvatar(radius: 50.r, backgroundColor: Colours.divider),
            SizedBox(height: 20.h),
            Text(
              CurrentUser().name,
              style: TextStyle(
                fontFamily: Fonts.bold,
                fontSize: 20.sp,
                color: Colours.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              CurrentUser().bio,
              style: TextStyle(fontFamily: Fonts.light, color: Colours.grey),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Obx(() {
              final controller = Get.find<AuthController>();
              return FilledButton(
                onPressed:
                    controller.signUpLoading.value
                        ? null
                        : () {
                          controller.signOut();
                        },
                child:
                    controller.signUpLoading.value
                        ? ButtonLoader()
                        : Text("Sign Out"),
              );
            }),
            SizedBox(height: 30.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Container(color: Colours.divider);
              },
            ),
          ],
        ),
      ),
    );
  }
}

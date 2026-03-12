import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/create_post/controllers/create_post_controller.dart';
import 'package:prosnap/features/location_picker/views/pick_location_screen.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  final TextEditingController captionField = TextEditingController();

  late final CreatePostController controller;

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = Get.put(CreatePostController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              fontSize: 14.sp,
                              color: Colours.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Create Post",
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 16.sp,
                            letterSpacing: 2,
                            color: Colours.white,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              controller.sharePost(caption: captionField.text);
                            }
                          },
                          child: Text(
                            "Share",
                            style: TextStyle(
                              fontFamily: Fonts.semiBold,
                              fontSize: 14.sp,
                              color: Colours.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: Colours.divider, thickness: 0.5),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(25),

                          FormField(
                            validator: (value) {
                              if (controller.imageUrl.isEmpty) {
                                return "Required !";
                              }
                            },
                            builder:
                                (field) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (field.hasError) ...[
                                      Text(field.errorText.toString()),
                                      12.verticalSpace,
                                    ],
                                    Obx(
                                      () =>
                                          controller.imageUrl.isEmpty
                                              ? GestureDetector(
                                                onTap: () {
                                                  controller.pickImage();
                                                },
                                                child: Container(
                                                  height: 320.h,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colours.divider,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .add_photo_alternate_outlined,
                                                      size: 40.sp,
                                                      color: Colours.white
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              : SizedBox(
                                                height: 250,
                                                child: GridView(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        mainAxisSpacing: 10,
                                                        crossAxisSpacing: 10,
                                                        mainAxisExtent: 120,
                                                      ),
                                                  children: List.generate(
                                                    controller.imageUrl.length <
                                                            6
                                                        ? controller
                                                                .imageUrl
                                                                .length +
                                                            1
                                                        : controller
                                                            .imageUrl
                                                            .length,
                                                    (index) =>
                                                        index ==
                                                                controller
                                                                    .imageUrl
                                                                    .length
                                                            ? GestureDetector(
                                                              onTap: () {
                                                                controller
                                                                    .pickImage();
                                                              },
                                                              child: Container(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            )
                                                            : Stack(
                                                              children: [
                                                                Positioned.fill(
                                                                  child: Image.file(
                                                                    File(
                                                                      controller
                                                                          .imageUrl[index],
                                                                    ),
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                  ),
                                                                ),
                                                                IconButton.filled(
                                                                  onPressed: () {
                                                                    controller
                                                                        .imageUrl
                                                                        .removeAt(
                                                                          index,
                                                                        );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                  ),
                                                ),
                                              ),
                                    ),
                                  ],
                                ),
                          ),

                          verticalSpace(35),

                          /// Caption
                          Text(
                            "Caption",
                            style: TextStyle(
                              fontFamily: Fonts.semiBold,
                              fontSize: 14.sp,
                              color: Colours.white,
                            ),
                          ),

                          verticalSpace(12),

                          TextField(
                            controller: captionField,
                            maxLines: 4,
                            cursorColor: Colours.white,
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              fontSize: 14.sp,
                              color: Colours.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Write something minimal...",
                              hintStyle: TextStyle(
                                fontFamily: Fonts.light,
                                color: Colours.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colours.white,
                                  width: 0.6,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colours.white,
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(16.w),
                            ),
                          ),

                          verticalSpace(30),

                          Obx(
                            () =>
                                controller.address.value != null
                                    ? Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        10.horizontalSpace,
                                        Text(
                                          controller
                                              .address
                                              .value
                                              ?.formatAddresss,
                                        ),
                                      ],
                                    )
                                    : _buildOptionTile(
                                      Icons.location_on_outlined,
                                      "Add Location",
                                      () async {
                                        Get.to(() => PickLocationScreen());
                                      },
                                    ),
                          ),

                          verticalSpace(15),

                          verticalSpace(40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(
              () =>
                  controller.sharingPost.value
                      ? Positioned.fill(
                        child: Container(
                          color: Colors.white.withOpacity(0.2),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colours.white, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colours.white.withOpacity(0.8)),
            horizontalSpace(15),
            Text(
              title,
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 14.sp,
                color: Colours.white,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Colours.white.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

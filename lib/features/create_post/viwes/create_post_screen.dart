import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey();
  final List<String> imageUrls = [];
  String selectedLocation = 'India';

  void _pickImage() {}

  void _sharePost() {
    if (formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const PickLocationScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        selectedLocation = result;
      });
    }
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
                            'Cancel',
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              fontSize: 14.sp,
                              color: Colours.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Create Post',
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 16.sp,
                            letterSpacing: 2,
                            color: Colours.white,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _sharePost,
                          child: Text(
                            'Share',
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
                  const Divider(color: Colours.divider, thickness: 0.5),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(25),
                          FormField(
                            validator: (value) {
                              if (imageUrls.isEmpty) {
                                return 'Required !';
                              }
                              return null;
                            },
                            builder: (field) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (field.hasError) ...[
                                  Text(field.errorText.toString()),
                                  verticalSpace(12),
                                ],
                                imageUrls.isEmpty
                                    ? GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          height: 320.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colours.divider,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add_photo_alternate_outlined,
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
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                            mainAxisExtent: 120,
                                          ),
                                          children: List.generate(
                                            imageUrls.length < 6
                                                ? imageUrls.length + 1
                                                : imageUrls.length,
                                            (index) => index == imageUrls.length
                                                ? GestureDetector(
                                                    onTap: _pickImage,
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                : Stack(
                                                    children: [
                                                      Positioned.fill(
                                                        child: Image.file(
                                                          File(imageUrls[index]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      IconButton.filled(
                                                        onPressed: () {
                                                          setState(() {
                                                            imageUrls.removeAt(
                                                              index,
                                                            );
                                                          });
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          verticalSpace(35),
                          Text(
                            'Caption',
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
                              hintText: 'Write something minimal...',
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
                            ),
                          ),
                          verticalSpace(30),
                          Text(
                            'Location',
                            style: TextStyle(
                              fontFamily: Fonts.semiBold,
                              fontSize: 14.sp,
                              color: Colours.white,
                            ),
                          ),
                          verticalSpace(12),
                          GestureDetector(
                            onTap: _openLocationPicker,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colours.white,
                                  width: 0.6,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colours.white,
                                  ),
                                  horizontalSpace(10),
                                  Expanded(
                                    child: Text(
                                      selectedLocation,
                                      style: TextStyle(
                                        fontFamily: Fonts.medium,
                                        fontSize: 14.sp,
                                        color: Colours.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          verticalSpace(30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

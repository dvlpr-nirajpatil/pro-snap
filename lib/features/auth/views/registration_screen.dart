import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/router/routes.dart';
import 'package:prosnap/features/auth/controllers/auth_controller.dart';
import 'package:prosnap/features/auth/views/sign_up_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final AuthController controller = Get.find<AuthController>();

  final TextEditingController userName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final ImagePicker imagePicker = ImagePicker();

  String? selectedGender;
  DateTime? selectedDate;
  XFile? selectedProfileImage;

  get birthDate {
    String day = selectedDate!.day.toString().padLeft(2, "0");
    String month = selectedDate!.month.toString().padLeft(2, "0");
    String year = selectedDate!.year.toString().padLeft(4, "0");

    return "$day/$month/$year";
  }

  Widget verticalSpace(double height) => SizedBox(height: height.h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(40),

                /// Logo
                Text(
                  "PRO SNAP",
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 28.sp,
                    letterSpacing: 6,
                    color: Colours.white,
                  ),
                ),

                verticalSpace(10),

                Text(
                  "Complete Profile",
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 14.sp,
                    letterSpacing: 1.5,
                    color: Colours.white.withValues(alpha: 0.7),
                  ),
                ),

                verticalSpace(40),

                /// Profile Image
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: _buildProfileImagePicker(),
                ),

                verticalSpace(40),

                _buildInputField(
                  "Username",
                  controller: userName,
                  isRequired: true,
                ),
                verticalSpace(18),

                _buildInputField(
                  "Full Name",
                  controller: fullName,
                  isRequired: true,
                ),
                verticalSpace(18),

                _buildGenderDropdown(),
                verticalSpace(18),

                _buildDobField(context),
                verticalSpace(18),

                _buildBioField(bio),
                verticalSpace(40),

                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.signUpLoading.value
                              ? null
                              : () {
                                if (formKey.currentState!.validate()) {
                                  controller
                                      .saveUserDetails(
                                        name: fullName.text,
                                        userName: userName.text,
                                        gender:
                                            selectedGender?.toLowerCase() ?? "",
                                        dob: dob.text,
                                        bio: bio.text,
                                        profileImagePath:
                                            selectedProfileImage?.path,
                                      )
                                      .then((e) {
                                        if (e) {
                                          Get.offAllNamed(Routes.homeScreen);
                                        }
                                      });
                                }
                              },
                      child:
                          controller.signUpLoading.value
                              ? ButtonLoader()
                              : Text("CONTINUE"),
                    ),
                  ),
                ),

                verticalSpace(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userName.dispose();
    dob.dispose();
    fullName.dispose();
    bio.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedProfileImage = image;
      });
    }
  }

  Widget _buildProfileImagePicker() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 110.h,
          width: 110.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colours.white, width: 1),
            image:
                selectedProfileImage == null
                    ? null
                    : DecorationImage(
                      image: FileImage(File(selectedProfileImage!.path)),
                      fit: BoxFit.cover,
                    ),
          ),
          child:
              selectedProfileImage == null
                  ? Icon(
                    Icons.add_a_photo_outlined,
                    color: Colours.white.withValues(alpha: 0.7),
                    size: 28.sp,
                  )
                  : null,
        ),
        Positioned(
          right: 0,
          bottom: 4.h,
          child: Container(
            height: 30.h,
            width: 30.h,
            decoration: const BoxDecoration(
              color: Colours.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              selectedProfileImage == null
                  ? Icons.add_rounded
                  : Icons.edit_rounded,
              color: Colours.primary,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String hint, {isRequired = false, controller}) {
    return TextFormField(
      controller: controller,
      validator:
          isRequired
              ? (value) {
                if (value == null || value == "") {
                  return "Required !";
                }
                return null;
              }
              : null,

      style: TextStyle(
        fontFamily: Fonts.medium,
        fontSize: 14.sp,
        color: Colours.white,
      ),
      cursorColor: Colours.white,
      decoration: _inputDecoration(hint),
    );
  }

  Widget _buildBioField(controller) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      style: TextStyle(
        fontFamily: Fonts.medium,
        fontSize: 14.sp,
        color: Colours.white,
      ),
      cursorColor: Colours.white,
      decoration: _inputDecoration("Bio"),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colours.primary,
      initialValue: selectedGender,
      style: TextStyle(fontFamily: Fonts.medium, color: Colours.white),
      decoration: _inputDecoration("Gender"),
      items:
          ["Male", "Female", "Other"]
              .map(
                (gender) =>
                    DropdownMenuItem(value: gender, child: Text(gender)),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          selectedGender = value;
        });
      },
    );
  }

  Widget _buildDobField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Colours.white,
                  onPrimary: Colours.primary,
                  surface: Colours.primary,
                  onSurface: Colours.white,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          setState(() {
            selectedDate = picked;
            dob.text = birthDate;
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: dob,
          validator: (value) {
            if (value == null || value == "") {
              return "Required !";
            }
            return null;
          },
          style: TextStyle(
            fontFamily: Fonts.medium,
            fontSize: 14.sp,
            color: Colours.white,
          ),
          cursorColor: Colours.white,
          decoration: _inputDecoration("DOB"),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: Fonts.light, color: Colours.grey),
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colours.white, width: 0.6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colours.white, width: 1),
      ),
    );
  }
}

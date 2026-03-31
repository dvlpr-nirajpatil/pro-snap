import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  String? selectedGender;
  DateTime? selectedDate;

  String get birthDate {
    final String day = selectedDate!.day.toString().padLeft(2, '0');
    final String month = selectedDate!.month.toString().padLeft(2, '0');
    final String year = selectedDate!.year.toString().padLeft(4, '0');
    return '$day/$month/$year';
  }

  Widget verticalSpace(double height) => SizedBox(height: height.h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(40),
                Text(
                  'PRO SNAP',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 28.sp,
                    letterSpacing: 6,
                    color: Colours.white,
                  ),
                ),
                verticalSpace(10),
                Text(
                  'Complete Profile',
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 14.sp,
                    letterSpacing: 1.5,
                    color: Colours.white.withOpacity(0.7),
                  ),
                ),
                verticalSpace(40),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 110.h,
                    width: 110.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colours.white, width: 1),
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colours.white.withOpacity(0.7),
                      size: 28.sp,
                    ),
                  ),
                ),
                verticalSpace(40),
                _buildInputField(
                  'Username',
                  controller: userName,
                  isRequired: true,
                ),
                verticalSpace(18),
                _buildInputField(
                  'Full Name',
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
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {}
                    },
                    child: const Text('CONTINUE'),
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

  Widget _buildInputField(
    String hint, {
    bool isRequired = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      validator:
          isRequired
              ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Required !';
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

  Widget _buildBioField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      style: TextStyle(
        fontFamily: Fonts.medium,
        fontSize: 14.sp,
        color: Colours.white,
      ),
      cursorColor: Colours.white,
      decoration: _inputDecoration('Bio'),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colours.primary,
      value: selectedGender,
      style: TextStyle(fontFamily: Fonts.medium, color: Colours.white),
      decoration: _inputDecoration('Gender'),
      items:
          ['Male', 'Female', 'Other']
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
    return TextFormField(
      controller: dob,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required !';
        }
        return null;
      },
      onTap: () async {
        final DateTime? picked = await showDatePicker(
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
      style: TextStyle(
        fontFamily: Fonts.medium,
        fontSize: 14.sp,
        color: Colours.white,
      ),
      cursorColor: Colours.white,
      decoration: _inputDecoration('DOB'),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent, width: 0.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }
}

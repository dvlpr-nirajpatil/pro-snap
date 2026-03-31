import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/navigation/app_navigator.dart';
import 'package:prosnap/features/auth/bloc/auth_bloc.dart';
import 'package:prosnap/features/auth/bloc/auth_event.dart';
import 'package:prosnap/features/auth/bloc/auth_state.dart';
import 'package:prosnap/router/router.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  Widget verticalSpace(double height) => SizedBox(height: height.h);

  final TextEditingController emailField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(70),
                Text(
                  'PRO SNAP',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 30.sp,
                    letterSpacing: 6,
                    color: Colours.white,
                  ),
                ),
                verticalSpace(12),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 14.sp,
                    letterSpacing: 1.5,
                    color: Colours.white.withOpacity(0.7),
                  ),
                ),
                verticalSpace(50),
                _buildInputField(
                  'Email',
                  false,
                  isRequired: true,
                  controller: emailField,
                ),
                verticalSpace(18),
                _buildInputField(
                  'Password',
                  true,
                  isRequired: true,
                  controller: passwordField,
                ),
                verticalSpace(58),
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    buildWhen:
                        (previous, current) => current is SignUpEventStates,
                    listenWhen:
                        (previous, current) => current is SignUpEventStates,
                    listener: (context, state) {
                      if (state is SignUpEventSuccessState) {
                        goRouter.goNamed(Routes.profileSetupScreen);
                      }

                      if (state is SignUpEventErrorState) {
                        AppNavigator.showAppSnackBar(state.error);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            SignUpEvent(
                              email: emailField.text,
                              password: passwordField.text,
                            ),
                          );
                        },
                        child:
                            state is SignUpEventLoadingState
                                ? ButtonLoader()
                                : Text('SIGN UP'),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontFamily: Fonts.light,
                        fontSize: 13.sp,
                        color: Colours.grey,
                      ),
                    ),
                    verticalSpace(8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: Fonts.semiBold,
                          fontSize: 14.sp,
                          letterSpacing: 1.2,
                          color: Colours.white,
                        ),
                      ),
                    ),
                  ],
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
    String hint,
    bool obscure, {
    bool isRequired = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      validator:
          isRequired
              ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              }
              : null,
      obscureText: obscure,
      style: TextStyle(
        fontFamily: Fonts.medium,
        fontSize: 14.sp,
        color: Colours.white,
      ),
      cursorColor: Colours.white,
      decoration: InputDecoration(
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
      ),
    );
  }
}

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 10,
      height: 10,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

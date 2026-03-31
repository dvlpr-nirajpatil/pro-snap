import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/navigation/app_navigator.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/features/auth/bloc/auth_bloc.dart';
import 'package:prosnap/features/auth/bloc/auth_event.dart';
import 'package:prosnap/features/auth/bloc/auth_state.dart';
import 'package:prosnap/features/auth/views/sign_up_screen.dart';
import 'package:prosnap/router/router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  Widget verticalSpace(double height) => SizedBox(height: height.h);

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpace(100),
              Text(
                'PRO SNAP',
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 32.sp,
                  letterSpacing: 6,
                  color: Colours.white,
                ),
              ),
              verticalSpace(12),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontFamily: Fonts.light,
                  fontSize: 14.sp,
                  letterSpacing: 1.5,
                  color: Colours.white.withOpacity(0.7),
                ),
              ),
              verticalSpace(60),
              _buildInputField(
                hint: 'Email',
                obscure: false,
                controller: email,
              ),
              verticalSpace(20),
              _buildInputField(
                hint: 'Password',
                obscure: true,
                controller: password,
              ),
              verticalSpace(40),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listenWhen:
                      (previous, current) => current is LoginEventStates,
                  buildWhen: (previous, current) => current is LoginEventStates,
                  listener: (context, state) {
                    if (state is LoginEventSuccessState) {
                      if (CurrentUser().registration) {
                        goRouter.goNamed(Routes.homeScreen);
                      } else {
                        goRouter.goNamed(Routes.profileSetupScreen);
                      }
                    }

                    if (state is LoginEventErrorState) {
                      AppNavigator.showAppSnackBar(state.error);
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (email.text.trim() != "" &&
                            password.text.trim() != "") {
                          context.read<AuthBloc>().add(
                            LoginEvent(
                              email: email.text,
                              password: password.text,
                            ),
                          );
                        }
                      },
                      child:
                          state is LoginEventLoadingState
                              ? ButtonLoader()
                              : Text('LOGIN'),
                    );
                  },
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 13.sp,
                      color: Colours.grey,
                    ),
                  ),
                  verticalSpace(8),
                  GestureDetector(
                    onTap: () {
                      goRouter.goNamed(Routes.signUpScreen);
                    },
                    child: Text(
                      'Create Account',
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
    );
  }

  Widget _buildInputField({
    required String hint,
    required bool obscure,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
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
        filled: true,
        fillColor: Colors.transparent,
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

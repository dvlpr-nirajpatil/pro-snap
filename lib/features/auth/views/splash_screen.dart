import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/auth/bloc/auth_bloc.dart';
import 'package:prosnap/features/auth/bloc/auth_event.dart';
import 'package:prosnap/features/auth/bloc/auth_state.dart';

import 'package:prosnap/router/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      context.read<AuthBloc>().add(HandleAppOpenEvent());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget verticalSpace(double height) => SizedBox(height: height.h);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is NavigateToHomeState) {
          goRouter.goNamed(Routes.homeScreen);
        }
        if (state is NavigateToLoginState) {
          goRouter.goNamed(Routes.loginScreen);
        }
        if (state is NavigateToRegistrationState) {
          goRouter.goNamed(Routes.profileSetupScreen);
        }
      },
      child: Scaffold(
        backgroundColor: Colours.primary,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(200),
                Text(
                  'PRO SNAP',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 36.sp,
                    letterSpacing: 6,
                    color: Colors.white,
                  ),
                ),
                verticalSpace(16),
                Text(
                  'Capture Silence',
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 14.sp,
                    letterSpacing: 2,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                Text(
                  '© 2026 Pro Snap',
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                verticalSpace(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

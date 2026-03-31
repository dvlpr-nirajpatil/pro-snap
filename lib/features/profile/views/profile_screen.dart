import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/core/navigation/app_navigator.dart';
import 'package:prosnap/features/auth/bloc/auth_bloc.dart';
import 'package:prosnap/features/auth/bloc/auth_event.dart';
import 'package:prosnap/features/auth/bloc/auth_state.dart';
import 'package:prosnap/features/auth/views/sign_up_screen.dart';
import 'package:prosnap/features/manage_profile/views/manage_profile_screen.dart';
import 'package:prosnap/features/profile/views/verified_subscription_screen.dart';
import 'package:prosnap/router/router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Text(
                  'pro_user',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 20.sp,
                    letterSpacing: 2,
                    color: Colours.white,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 45.r,
                          backgroundColor: Colours.divider,
                        ),
                        horizontalSpace(30),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStat('120', 'Posts'),
                              _buildStat('5.2K', 'Followers'),
                              _buildStat('380', 'Following'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    Text(
                      'Pro User',
                      style: TextStyle(
                        fontFamily: Fonts.semiBold,
                        fontSize: 14.sp,
                        color: Colours.white,
                      ),
                    ),
                    verticalSpace(6),
                    Text(
                      'Capturing minimal moments in silence.\nLuxury • Editorial • Black & White',
                      style: TextStyle(
                        fontFamily: Fonts.light,
                        fontSize: 13.sp,
                        color: Colours.white.withValues(alpha: 0.8),
                      ),
                    ),
                    verticalSpace(20),
                    _buildVerifiedCard(context),
                    verticalSpace(20),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ManageProfileScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colours.white,
                                width: 0.8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              'Manage Profile',
                              style: TextStyle(
                                fontFamily: Fonts.medium,
                                fontSize: 13.sp,
                                letterSpacing: 1,
                                color: Colours.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          BlocConsumer<AuthBloc, AuthState>(
                            buildWhen:
                                (previous, current) =>
                                    current is SignOutEvemtStates,
                            listenWhen:
                                (previous, current) =>
                                    current is SignOutEvemtStates,
                            listener: (context, state) {
                              if (state is SignOutEvemtSuccessState) {
                                goRouter.goNamed(Routes.loginScreen);
                              }
                              if (state is SignOutEvemtErrorState) {
                                AppNavigator.showAppSnackBar(state.error);
                              }
                            },
                            builder: (context, state) {
                              return OutlinedButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(SignOutEvent());
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colours.white,
                                    width: 0.8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child:
                                    state is SignOutEvemtLoadingState
                                        ? ButtonLoader()
                                        : Text(
                                          'Sign Out',
                                          style: TextStyle(
                                            fontFamily: Fonts.medium,
                                            fontSize: 13.sp,
                                            letterSpacing: 1,
                                            color: Colours.white,
                                          ),
                                        ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(25),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(color: Colours.divider, thickness: 0.5),
            ),
            SliverPadding(
              padding: EdgeInsets.all(2.w),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(color: Colours.divider);
                }, childCount: 18),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontFamily: Fonts.semiBold,
            fontSize: 15.sp,
            color: Colours.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.light,
            fontSize: 12.sp,
            color: Colours.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifiedCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF0F3D91)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colours.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42.h,
                width: 42.h,
                decoration: BoxDecoration(
                  color: Colours.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_rounded,
                  color: Colours.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get Verified',
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        fontSize: 16.sp,
                        color: Colours.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Buy a verified tick to boost trust and profile visibility.',
                      style: TextStyle(
                        fontFamily: Fonts.light,
                        fontSize: 12.sp,
                        color: Colours.white.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(16),
          Row(
            children: [
              _buildVerifiedPill('Blue badge'),
              horizontalSpace(8),
              _buildVerifiedPill('Priority support'),
            ],
          ),
          verticalSpace(16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VerifiedSubscriptionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colours.white,
                foregroundColor: Colours.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'See Plans',
                style: TextStyle(
                  fontFamily: Fonts.semiBold,
                  fontSize: 13.sp,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedPill(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colours.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: Fonts.medium,
          fontSize: 11.sp,
          color: Colours.white,
        ),
      ),
    );
  }
}

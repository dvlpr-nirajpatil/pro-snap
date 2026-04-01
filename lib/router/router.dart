import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prosnap/features/auth/views/login_screen.dart';
import 'package:prosnap/features/home/cubits/posts_cubit/posts_cubit.dart';
import 'package:prosnap/features/home/cubits/stories_cubit/stories_cubit.dart';
import 'package:prosnap/features/profile_setup/cubit/profile_setup_cubit.dart';
import 'package:prosnap/features/profile_setup/pages/registration_screen.dart';
import 'package:prosnap/features/auth/views/sign_up_screen.dart';
import 'package:prosnap/features/auth/views/splash_screen.dart';
import 'package:prosnap/features/navbar/views/nav_screen.dart';

class Routes {
  static final splashScreen = "SplashScreen";
  static final loginScreen = "LoginScreen";
  static final signUpScreen = "SignUpScreen";
  static final profileSetupScreen = "registerUser";
  static final homeScreen = "homeScreen";
}

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: Routes.splashScreen,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/loginScreen',
      name: Routes.loginScreen,
      builder: (context, state) => LoginScreen(),
      routes: [
        GoRoute(
          path: 'signUpScreen',
          name: Routes.signUpScreen,
          builder: (context, state) => SignupScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/registerUser',
      name: Routes.profileSetupScreen,
      builder:
          (context, state) => BlocProvider(
            create: (context) => ProfileSetupCubit(),
            child: ProfileSetupScreen(),
          ),
    ),
    GoRoute(
      path: '/home',
      name: Routes.homeScreen,
      builder:
          (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PostsCubit()),
              BlocProvider(create: (_) => StoriesCubit()),
            ],
            child: MainNavScreen(),
          ),
    ),
  ],
);

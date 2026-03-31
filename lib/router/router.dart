import 'package:go_router/go_router.dart';
import 'package:prosnap/features/auth/views/login_screen.dart';
import 'package:prosnap/features/auth/views/registration_screen.dart';
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
      builder: (context, state) => ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/home',
      name: Routes.homeScreen,
      builder: (context, state) => MainNavScreen(),
    ),
  ],
);

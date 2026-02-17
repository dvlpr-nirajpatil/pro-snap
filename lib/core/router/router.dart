import 'package:prosnap/core/router/routes.dart';
import 'package:prosnap/features/auth/views/splash_screen.dart';
import 'package:get/route_manager.dart';
import 'package:prosnap/features/navbar/bindings/home_bindings.dart';
import 'package:prosnap/features/navbar/views/nav_screen.dart';

class GetRoutes {
  static List<GetPage> routes = [
    GetPage(name: Routes.splashScreen, page: () => SplashScreen()),
    GetPage(
      name: Routes.homeScreen,
      page: () => MainNavScreen(),
      binding: HomeBindings(),
    ),
  ];
}

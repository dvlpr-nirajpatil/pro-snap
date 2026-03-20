import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/theme.dart';
import 'package:prosnap/core/global/initial_bindings.dart';
import 'package:prosnap/core/router/router.dart';
import 'package:prosnap/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/core/services/local_db.dart';
import 'package:prosnap/core/services/notification_service.dart';
import 'package:prosnap/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDb().init();
  CurrentUser().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService().init();
  runApp(MealsDB());
}

class MealsDB extends StatelessWidget {
  const MealsDB({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, widget) => GetMaterialApp(
            theme: buildDarkTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splashScreen,
            initialBinding: InitialBindings(),
            getPages: GetRoutes.routes,
          ),
    );
  }
}

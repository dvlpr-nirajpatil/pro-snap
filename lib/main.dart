import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/theme.dart';
import 'package:prosnap/core/navigation/app_navigator.dart';
import 'package:prosnap/core/services/app_services.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/core/services/local_db.dart';
import 'package:prosnap/features/auth/bloc/auth_bloc.dart';
import 'package:prosnap/firebase_options.dart';
import 'package:prosnap/locator.dart';
import 'package:prosnap/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  await LocalDb().init();
  CurrentUser().init();
  await AppServices.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NotificationService().init();
  runApp(const MealsDB());
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
          (context, widget) => MultiBlocProvider(
            providers: [BlocProvider.value(value: sl.get<AuthBloc>())],
            child: MaterialApp.router(
              scaffoldMessengerKey: AppNavigator.messengerKey,
              theme: buildDarkTheme(),
              debugShowCheckedModeBanner: false,
              routerConfig: goRouter,
            ),
          ),
    );
  }
}

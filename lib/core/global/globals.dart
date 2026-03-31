import 'package:logger/logger.dart';
import 'package:prosnap/core/navigation/app_navigator.dart';
import 'package:prosnap/core/network/api_exception.dart';

Logger logger = Logger();

void errorHandle(dynamic e) {
  if (e is ApiException) {
    AppNavigator.showSnackBar('Api Error', e.message);
  } else if (e is NoInternetException) {
    AppNavigator.showSnackBar('No Internet', e.message);
  } else {
    logger.e(e);
  }
}

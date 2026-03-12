import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:logger/logger.dart';
import 'package:prosnap/core/network/api_exception.dart';

Logger logger = Logger();
errorHandle(e) {
  if (e is ApiException) {
    Get.snackbar("Api Error !", e.message);
  } else if (e is NoInternetException) {
    Get.snackbar("No Internet", e.message);
  } else {
    logger.e(e);
  }
}

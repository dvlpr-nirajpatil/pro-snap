import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prosnap/core/global/globals.dart';

abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException()
    : super(message: "No internet connection. Please try again.");
}

class ApiException extends AppException {
  const ApiException({required super.message, super.statusCode});
}

handelError(e) {
  if (e is ApiException) {
    Get.snackbar("Error !", e.message);
  } else if (e is NoInternetException) {
    Get.snackbar("No Internet !", e.message);
  } else {
    logger.e(e);
  }
}

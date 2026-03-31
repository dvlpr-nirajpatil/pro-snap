import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/navigation/app_navigator.dart';

abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException()
      : super(message: 'No internet connection. Please try again.');
}

class ApiException extends AppException {
  const ApiException({required super.message, super.statusCode});
}

void handelError(dynamic e) {
  if (e is ApiException) {
    AppNavigator.showSnackBar('Error', e.message);
  } else if (e is NoInternetException) {
    AppNavigator.showSnackBar('No Internet', e.message);
  } else {
    logger.e(e);
  }
}

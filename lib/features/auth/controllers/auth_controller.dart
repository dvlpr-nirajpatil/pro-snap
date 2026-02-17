import 'package:get/get.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/core/router/routes.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/core/services/tokens.dart';
import 'package:prosnap/features/auth/repository/auth_repository.dart';
import 'package:prosnap/features/auth/views/login_screen.dart';
import 'package:prosnap/features/auth/views/registration_screen.dart';

class AuthController extends GetxController {
  final AuthRepository repository = AuthRepository();

  RxBool signUpLoading = false.obs;

  handleAppOpen() async {
    try {
      final refreshToken = await Tokens.refreshToken;
      if (refreshToken == null) {
        Get.off(() => LoginScreen());
      } else {
        await repository.refreshToken();
        await repository.getCurrentUserDetails();
        if (CurrentUser().registration) {
          Get.offAllNamed(Routes.homeScreen);
        } else {
          Get.offAll(() => ProfileSetupScreen());
        }
      }
    } catch (e) {
      CurrentUser().delete();
      Tokens.clear();
      Get.offAll(() => LoginScreen());
    }
  }

  signUp({required String email, required String password}) async {
    signUpLoading.value = true;
    try {
      await repository.signUp(email: email, password: password);
      signUpLoading.value = false;
      return true;
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar("Error", e.message);
      }
      if (e is NoInternetException) {
        Get.snackbar("Error", e.message);
      }
    } finally {
      signUpLoading.value = false;
    }
    return false;
  }

  signIn({required String email, required String password}) async {
    signUpLoading.value = true;
    try {
      await repository.signIn(email: email, password: password);

      if (CurrentUser().registration) {
        Get.offAllNamed(Routes.homeScreen);
      } else {
        Get.offAll(() => ProfileSetupScreen());
      }
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar("Error", e.message);
      }
      if (e is NoInternetException) {
        Get.snackbar("Error", e.message);
      }
    } finally {
      signUpLoading.value = false;
    }
    return false;
  }

  saveUserDetails({
    required String name,
    required String userName,
    required String gender,
    required String dob,
    required String bio,
  }) async {
    signUpLoading.value = true;
    try {
      await repository.saveUserDetails(
        name: name,
        userName: userName,
        gender: gender,
        dob: dob,
        bio: bio,
      );
      signUpLoading.value = false;
      return true;
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar("Error", e.message);
      }
      if (e is NoInternetException) {
        Get.snackbar("Error", e.message);
      }
    } finally {
      signUpLoading.value = false;
    }
    return false;
  }

  signOut() async {
    signUpLoading.value = true;
    try {
      await repository.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar("Error !", e.message);
      }
      if (e is NoInternetException) {
        Get.snackbar("Error ", e.message);
      }
    } finally {
      signUpLoading.value = false;
    }
  }
}

import 'package:get/get.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/features/profile_details/models/profile_details.dart';
import 'package:prosnap/features/profile_details/repository/profile_details_repository.dart';

class ProfileDetailsController extends GetxController {
  final ProfileDetailsRepository repository = ProfileDetailsRepository();

  Rxn<ProfileDetails> details = Rxn<ProfileDetails>();
  RxBool isLoading = false.obs;

  getProfileDetails(id) async {
    isLoading.value = true;
    try {
      details.value = await repository.getProfileDetails(id);
    } catch (e) {
      errorHandle(e);
    } finally {
      isLoading.value = false;
    }
  }
}

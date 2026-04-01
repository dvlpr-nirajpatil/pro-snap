import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/features/profile_setup/repository/profile_setup_repository.dart';

part 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final ProfileSetupRepository repository = ProfileSetupRepository();

  ProfileSetupCubit() : super(ProfileSetupInitial());

  final ImagePicker _imagePicker = ImagePicker();

  String? imagePath;

  pickImage() async {
    emit(PickImageLoadingState());

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      imagePath = image.path;
    }

    emit(PickImageSuccessState());
  }

  submitUserDetails({
    required String userName,
    required String fullName,
    required String gender,
    required String dob,
    required String bio,
  }) async {
    emit(SubmitDetailsLoadingState());
    try {
      String? imageUrl;

      if (imagePath != null) {
        imageUrl = await repository.uploadProfilePicture(imagePath);
      }

      await repository.saveUserDetails(
        name: fullName,
        userName: userName,
        gender: gender,
        dob: dob,
        bio: bio,
        profilePicture: imageUrl,
      );

      emit(SubmitDetailsSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(SubmitDetailsErrorState(error: e.message));
      } else {
        logger.e(e);
        emit(SubmitDetailsErrorState(error: e.toString()));
      }
    }
  }
}

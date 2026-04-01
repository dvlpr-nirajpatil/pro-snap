part of 'profile_setup_cubit.dart';

sealed class ProfileSetupState extends Equatable {
  const ProfileSetupState();

  @override
  List<Object> get props => [];
}

final class ProfileSetupInitial extends ProfileSetupState {}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// PICK IMAGE EVENT STATES
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class PickImageStates extends ProfileSetupState {}

class PickImageLoadingState extends PickImageStates {}

class PickImageSuccessState extends PickImageStates {}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// SUBMIT DETAILS EVENT STATES
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class SubmitDetailsStates extends ProfileSetupState {}

class SubmitDetailsLoadingState extends SubmitDetailsStates {}

class SubmitDetailsSuccessState extends SubmitDetailsStates {}

class SubmitDetailsErrorState extends SubmitDetailsStates {
  final String error;

  SubmitDetailsErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// -------------------------------------------------------------------------------------------------------------------
/// SIGN UP EVENT STATES
/// -------------------------------------------------------------------------------------------------------------------

class LoginEventStates extends AuthState {}

class LoginEventSuccessState extends LoginEventStates {}

class LoginEventLoadingState extends LoginEventStates {}

class LoginEventErrorState extends LoginEventStates {
  final String error;

  LoginEventErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

/// -------------------------------------------------------------------------------------------------------------------
///  SIGN UP EVENT STATES
/// -------------------------------------------------------------------------------------------------------------------

class SignUpEventStates extends AuthState {}

class SignUpEventLoadingState extends SignUpEventStates {}

class SignUpEventSuccessState extends SignUpEventStates {}

class SignUpEventErrorState extends SignUpEventStates {
  final String error;

  SignUpEventErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

/// -------------------------------------------------------------------------------------------------------------------
/// SIGN OUT
/// -------------------------------------------------------------------------------------------------------------------

class SignOutEvemtStates extends AuthState {}

class SignOutEvemtLoadingState extends SignOutEvemtStates {}

class SignOutEvemtSuccessState extends SignOutEvemtStates {}

class SignOutEvemtErrorState extends SignOutEvemtStates {
  final String error;
  final DateTime _dateTime = DateTime.now();
  SignOutEvemtErrorState({required this.error});
  @override
  List<Object> get props => [error, _dateTime];
}

/// -------------------------------------------------------------------------------------------------------------------
/// HANDLE APP OPEN STATES
/// -------------------------------------------------------------------------------------------------------------------

class HandleAppOpenEventStates extends AuthState {}

class NavigateToHomeState extends HandleAppOpenEventStates {}

class NavigateToLoginState extends HandleAppOpenEventStates {}

class NavigateToRegistrationState extends HandleAppOpenEventStates {}

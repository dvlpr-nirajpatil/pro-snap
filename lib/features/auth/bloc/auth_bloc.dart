import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/network/api_exception.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/core/services/tokens.dart';
import 'package:prosnap/features/auth/bloc/auth_event.dart';
import 'package:prosnap/features/auth/bloc/auth_state.dart';
import 'package:prosnap/features/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  AuthBloc(this.repository) : super(AuthState()) {
    on<LoginEvent>(_loginEvent);
    on<SignUpEvent>(_signUpEvent);
    on<SignOutEvent>(_signOutEvent);
    on<HandleAppOpenEvent>(_handleAppOpenEvent);
  }

  /// -------------------------------------------------------------------------------------------------------------------
  ///  LOGIN EVENT
  /// -------------------------------------------------------------------------------------------------------------------

  _loginEvent(LoginEvent event, emit) async {
    emit(LoginEventLoadingState());
    try {
      await repository.signIn(email: event.email, password: event.password);
      emit(LoginEventSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(LoginEventErrorState(error: e.message));
      } else {
        logger.e(e);
        emit(LoginEventErrorState(error: e.toString()));
      }
    }
  }

  /// -------------------------------------------------------------------------------------------------------------------
  ///  SIGN UP EVENT
  /// -------------------------------------------------------------------------------------------------------------------

  _signUpEvent(SignUpEvent event, emit) async {
    emit(SignUpEventLoadingState());
    try {
      await repository.signUp(email: event.email, password: event.password);
      emit(SignUpEventSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(SignUpEventErrorState(error: e.message));
      } else {
        logger.e(e);
        emit(SignUpEventErrorState(error: e.toString()));
      }
    }
  }

  /// -------------------------------------------------------------------------------------------------------------------
  /// SIGN OUT EVENT
  /// -------------------------------------------------------------------------------------------------------------------
  _signOutEvent(SignOutEvent event, emit) async {
    emit(SignOutEvemtLoadingState());
    try {
      await repository.signOut();
      emit(SignOutEvemtSuccessState());
    } catch (e) {
      if (e is AppException) {
        emit(SignOutEvemtErrorState(error: e.message));
      } else {
        logger.e(e);
        emit(SignOutEvemtErrorState(error: e.toString()));
      }
    }
  }

  /// -------------------------------------------------------------------------------------------------------------------
  ///  HANDLE APP OPEN EVENT
  /// -------------------------------------------------------------------------------------------------------------------

  _handleAppOpenEvent(HandleAppOpenEvent event, emit) async {
    try {
      final refreshToken = await Tokens.refreshToken;

      if (refreshToken == null) {
        emit(NavigateToLoginState());
        return;
      }

      await repository.refreshToken();
      await repository.getCurrentUserDetails();

      if (CurrentUser().registration) {
        emit(NavigateToHomeState());
      } else {
        emit(NavigateToRegistrationState());
      }
    } catch (e) {
      emit(NavigateToLoginState());
    }
  }
}

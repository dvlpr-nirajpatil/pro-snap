import 'package:get_it/get_it.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/features/auth/bloc/auth_bloc.dart';
import 'package:prosnap/features/auth/repository/auth_repository.dart';

final sl = GetIt.asNewInstance();

injectDependencies() {
  /// -------------------------------------------------------------------------------------------------------------------
  /// API CLIENT
  /// -------------------------------------------------------------------------------------------------------------------
  sl.registerLazySingleton(() => ApiClient());

  /// -------------------------------------------------------------------------------------------------------------------
  ///  AUTH DEPENCIES
  /// -------------------------------------------------------------------------------------------------------------------
  sl.registerLazySingleton(() => AuthRepository());
  sl.registerLazySingleton(() => AuthBloc(sl.get<AuthRepository>()));
}

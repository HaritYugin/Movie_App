import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.getLoggedInUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.login(event.username, event.password);
      final user = await authRepository.getLoggedInUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Login failed unexpectedly.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.register(event.username, event.password);
      // After successful registration, automatically log in the user
      await authRepository.login(event.username, event.password);
      final user = await authRepository.getLoggedInUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Registration failed unexpectedly.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }
}

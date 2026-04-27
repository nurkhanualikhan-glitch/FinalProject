import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void checkAuthState() {
    final user = _auth.currentUser;

    if (user == null) {
      emit(Unauthenticated());
    } else {
      emit(Authenticated(user));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      emit(AuthLoading());

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(username);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      emit(Authenticated(credential.user!));
    } on FirebaseAuthException catch (error) {
      emit(AuthError(error.message ?? 'Registration failed'));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

Future<void> login({
  required String email,
  required String password,
}) async {
  try {
    emit(AuthLoading());

    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    emit(Authenticated(credential.user!));
  } on FirebaseAuthException catch (error) {
    if (error.code == 'user-not-found' ||
        error.code == 'invalid-credential' ||
        error.code == 'wrong-password') {
      emit(AuthError('Account not found. Please register first.'));
    } else {
      emit(AuthError(error.message ?? 'Login failed'));
    }
  } catch (error) {
    emit(AuthError(error.toString()));
  }
}

  Future<void> logout() async {
    await _auth.signOut();
    emit(Unauthenticated());
  }
}

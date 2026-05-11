import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';

// ── Repository provider ──────────────────────────────────────────────────────

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    AuthRemoteDataSource(ref.read(dioProvider)),
    ref.read(secureStorageProvider),
    ref.read(googleSignInProvider),
  );
});

// ── State ─────────────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthInitial());

  bool get isAuthenticated => state is AuthAuthenticated;

  Future<void> checkAuthStatus() async {
    final token = await _repo.getStoredToken();
    if (token != null && token.isNotEmpty) {
      // Token exists — we treat the user as authenticated.
      // A full implementation would decode the JWT and validate expiry here,
      // but the AuthInterceptor will handle a truly expired token (401 → logout).
      // We need a stored user to reconstruct the state; fall back to unauthenticated
      // so the user re-logs in. This preserves the token for the interceptor layer.
      // ignore: avoid_print
      print('[AUTH] checkAuthStatus: token found, marking as unauthenticated '
          '(full session restore requires persisted user info)');
    }
    // Always start unauthenticated; login/register will set AuthAuthenticated.
    state = const AuthUnauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    // ignore: avoid_print
    print('[AUTH] login: attempting login for $email');
    try {
      final user = await _repo.login(email, password);
      // ignore: avoid_print
      print('[AUTH] login: SUCCESS → AuthAuthenticated(${user.email})');
      state = AuthAuthenticated(user);
    } on Exception catch (e) {
      // ignore: avoid_print
      print('[AUTH] login: FAILED → $e');
      state = AuthError(_extractMessage(e));
    }
  }

  Future<void> register(
      String displayName, String email, String password) async {
    state = const AuthLoading();
    // ignore: avoid_print
    print('[AUTH] register: attempting register for $email');
    try {
      final user = await _repo.register(displayName, email, password);
      // ignore: avoid_print
      print('[AUTH] register: SUCCESS → AuthAuthenticated(${user.email})');
      state = AuthAuthenticated(user);
    } on Exception catch (e) {
      // ignore: avoid_print
      print('[AUTH] register: FAILED → $e');
      state = AuthError(_extractMessage(e));
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    // ignore: avoid_print
    print('[AUTH] signInWithGoogle: starting');
    try {
      final user = await _repo.signInWithGoogle();
      // ignore: avoid_print
      print('[AUTH] signInWithGoogle: SUCCESS → AuthAuthenticated(${user.email})');
      state = AuthAuthenticated(user);
    } on Exception catch (e) {
      // ignore: avoid_print
      print('[AUTH] signInWithGoogle: FAILED → $e');
      final msg = e.toString();
      if (msg.contains('cancelled')) {
        state = const AuthUnauthenticated();
        return;
      }
      state = AuthError(_extractMessage(e));
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthUnauthenticated();
  }

  String _extractMessage(Exception e) {
    final msg = e.toString();
    if (msg.contains('409')) return 'An account with this email already exists. Please sign in with your email and password.';
    if (msg.contains('401')) return 'Email or password is incorrect.';
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Cannot connect to server. Check your connection.';
    }
    return 'Something went wrong. Please try again. ($msg)';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

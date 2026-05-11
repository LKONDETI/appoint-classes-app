import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;
  final GoogleSignIn _googleSignIn;

  const AuthRepositoryImpl(this._remote, this._storage, this._googleSignIn);

  @override
  Future<AuthUser> login(String email, String password) async {
    final response = await _remote.login(email, password);
    await _storage.saveToken(response.token);
    return AuthUser(
      id: response.user.id,
      email: response.user.email,
      displayName: response.user.displayName,
      token: response.token,
    );
  }

  @override
  Future<AuthUser> register(
      String displayName, String email, String password) async {
    final response = await _remote.register(displayName, email, password);
    await _storage.saveToken(response.token);
    return AuthUser(
      id: response.user.id,
      email: response.user.email,
      displayName: response.user.displayName,
      token: response.token,
    );
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Google sign-in cancelled.');

    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) throw Exception('Failed to obtain Google ID token.');

    final response = await _remote.socialAuth(idToken, 'google');
    await _storage.saveToken(response.token);
    return AuthUser(
      id: response.user.id,
      email: response.user.email,
      displayName: response.user.displayName,
      token: response.token,
    );
  }

  @override
  Future<void> logout() => _storage.clearToken();

  @override
  Future<String?> getStoredToken() => _storage.getToken();
}

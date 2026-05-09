import '../entities/auth_user.dart';

abstract interface class IAuthRepository {
  Future<AuthUser> login(String email, String password);
  Future<AuthUser> register(String displayName, String email, String password);
  Future<void> logout();
  Future<String?> getStoredToken();
}

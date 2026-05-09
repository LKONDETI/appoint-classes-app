class AuthUser {
  final String id;
  final String email;
  final String displayName;
  final String token;

  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.token,
  });
}

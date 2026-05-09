class Profile {
  final String id;
  final String userId;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.userId,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.phoneNumber,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });
}

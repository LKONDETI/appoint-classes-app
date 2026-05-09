import '../entities/profile.dart';

abstract interface class IProfileRepository {
  Future<Profile> getProfile();
  Future<Profile> updateProfile(String displayName, String? phoneNumber, String? bio, String? avatarUrl);
}

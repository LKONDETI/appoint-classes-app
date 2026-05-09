import '../../domain/entities/profile.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource _remote;

  const ProfileRepositoryImpl(this._remote);

  @override
  Future<Profile> getProfile() async {
    final model = await _remote.getProfile();
    return _toEntity(model);
  }

  @override
  Future<Profile> updateProfile(
      String displayName, String? phoneNumber, String? bio, String? avatarUrl) async {
    final model = await _remote.updateProfile(displayName, phoneNumber, bio, avatarUrl);
    return _toEntity(model);
  }

  Profile _toEntity(ProfileModel m) => Profile(
        id: m.id,
        userId: m.userId,
        email: m.email,
        displayName: m.displayName,
        avatarUrl: m.avatarUrl,
        phoneNumber: m.phoneNumber,
        bio: m.bio,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
      );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/i_profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ProfileRemoteDataSource(ref.read(dioProvider)),
  );
});

sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  const ProfileLoaded(this.profile);
}

class ProfileSaving extends ProfileState {
  final Profile profile;
  const ProfileSaving(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final IProfileRepository _repo;

  ProfileNotifier(this._repo) : super(const ProfileLoading());

  Future<void> loadProfile() async {
    state = const ProfileLoading();
    try {
      final profile = await _repo.getProfile();
      state = ProfileLoaded(profile);
    } on Exception catch (e) {
      state = ProfileError(e.toString());
    }
  }

  Future<void> updateProfile(
      String displayName, String? phoneNumber, String? bio, {String? avatarUrl}) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    state = ProfileSaving(current.profile);
    try {
      final profile = await _repo.updateProfile(displayName, phoneNumber, bio, avatarUrl);
      state = ProfileLoaded(profile);
    } on Exception catch (e) {
      state = ProfileLoaded(current.profile);
      // Re-throw so the UI can show the error
      throw Exception(e.toString());
    }
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref.read(profileRepositoryProvider));
});

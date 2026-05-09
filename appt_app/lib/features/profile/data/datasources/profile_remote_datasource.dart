import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  const ProfileRemoteDataSource(this._dio);

  Future<ProfileModel> getProfile() async {
    final response = await _dio.get(ApiConstants.profile);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ProfileModel> updateProfile(
    String displayName,
    String? phoneNumber,
    String? bio,
    String? avatarUrl,
  ) async {
    final response = await _dio.put(
      ApiConstants.profile,
      data: {
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'bio': bio,
        'avatarUrl': avatarUrl,
      },
    );
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}

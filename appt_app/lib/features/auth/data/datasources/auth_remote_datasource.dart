import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSource(this._dio);

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponseModel> register(
      String displayName, String email, String password) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: {'displayName': displayName, 'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}

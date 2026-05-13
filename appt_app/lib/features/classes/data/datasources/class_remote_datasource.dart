import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/class_model.dart';

class ClassRemoteDataSource {
  final Dio _dio;

  const ClassRemoteDataSource(this._dio);

  Future<List<ClassModel>> getUpcoming(int limit) async {
    final response = await _dio.get(
      ApiConstants.classes,
      queryParameters: {'limit': limit},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((item) => ClassModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

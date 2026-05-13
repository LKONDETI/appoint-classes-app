import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  final Dio _dio;

  const BookingRemoteDataSource(this._dio);

  Future<BookingModel> createBooking(String classId) async {
    final response = await _dio.post(
      ApiConstants.bookings,
      data: {'classId': classId},
    );
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<BookingModel>> getMyBookings() async {
    final response = await _dio.get(ApiConstants.myBookings);
    final list = response.data as List<dynamic>;
    return list
        .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

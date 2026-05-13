import '../entities/booking_entity.dart';

abstract interface class IBookingRepository {
  Future<BookingEntity> createBooking(String classId);
  Future<List<BookingEntity>> getMyBookings();
}

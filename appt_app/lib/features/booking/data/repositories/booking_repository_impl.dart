import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/i_booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements IBookingRepository {
  final BookingRemoteDataSource _remote;

  const BookingRepositoryImpl(this._remote);

  @override
  Future<BookingEntity> createBooking(String classId) async {
    final model = await _remote.createBooking(classId);
    return _toEntity(model);
  }

  @override
  Future<List<BookingEntity>> getMyBookings() async {
    final models = await _remote.getMyBookings();
    return models.map(_toEntity).toList();
  }

  BookingEntity _toEntity(BookingModel m) => BookingEntity(
        id: m.id,
        classId: m.classId,
        classTitle: m.classTitle,
        scheduledAt: m.scheduledAt,
        bookedAt: m.bookedAt,
        status: m.status,
      );
}

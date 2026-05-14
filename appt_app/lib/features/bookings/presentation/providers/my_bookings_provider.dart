import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../booking/data/datasources/booking_remote_datasource.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../../booking/domain/repositories/i_booking_repository.dart';

final myBookingsRepositoryProvider = Provider<IBookingRepository>((ref) {
  return BookingRepositoryImpl(
    BookingRemoteDataSource(ref.read(dioProvider)),
  );
});

sealed class MyBookingsState {
  const MyBookingsState();
}

class MyBookingsInitial extends MyBookingsState {
  const MyBookingsInitial();
}

class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading();
}

class MyBookingsLoaded extends MyBookingsState {
  final List<BookingEntity> bookings;
  const MyBookingsLoaded(this.bookings);
}

class MyBookingsError extends MyBookingsState {
  final String message;
  const MyBookingsError(this.message);
}

class MyBookingsNotifier extends StateNotifier<MyBookingsState> {
  final IBookingRepository _repository;

  MyBookingsNotifier(this._repository) : super(const MyBookingsInitial());

  Future<void> loadMyBookings() async {
    state = const MyBookingsLoading();
    try {
      final bookings = await _repository.getMyBookings();
      state = MyBookingsLoaded(bookings);
    } on Exception catch (e) {
      state = MyBookingsError(e.toString());
    }
  }
}

final myBookingsProvider =
    StateNotifierProvider<MyBookingsNotifier, MyBookingsState>((ref) {
  return MyBookingsNotifier(ref.read(myBookingsRepositoryProvider));
});

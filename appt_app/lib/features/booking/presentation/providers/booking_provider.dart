import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/i_booking_repository.dart';
import '../../../classes/presentation/providers/class_provider.dart';

final bookingRepositoryProvider = Provider<IBookingRepository>((ref) {
  return BookingRepositoryImpl(
    BookingRemoteDataSource(ref.read(dioProvider)),
  );
});

sealed class BookingActionState {
  const BookingActionState();
}

class BookingActionIdle extends BookingActionState {
  const BookingActionIdle();
}

class BookingActionLoading extends BookingActionState {
  const BookingActionLoading();
}

class BookingActionSuccess extends BookingActionState {
  final BookingEntity booking;
  const BookingActionSuccess(this.booking);
}

class BookingActionError extends BookingActionState {
  final String message;
  const BookingActionError(this.message);
}

class BookingNotifier extends StateNotifier<BookingActionState> {
  final IBookingRepository _repo;
  final Ref _ref;

  BookingNotifier(this._repo, this._ref) : super(const BookingActionIdle());

  Future<void> bookClass(String classId) async {
    state = const BookingActionLoading();
    try {
      final booking = await _repo.createBooking(classId);
      state = BookingActionSuccess(booking);
      _ref.read(classProvider.notifier).loadClasses();
    } on DioException catch (e) {
      final errorCode = e.response?.data?['errorCode'] as String?;
      final message = switch (errorCode) {
        'CLASS_FULL' => 'Class is full.',
        'ALREADY_BOOKED' => 'Already booked.',
        _ => 'Booking failed. Please try again.',
      };
      state = BookingActionError(message);
    } on Exception {
      state = const BookingActionError('Booking failed. Please try again.');
    }
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingActionState>((ref) {
  return BookingNotifier(ref.read(bookingRepositoryProvider), ref);
});

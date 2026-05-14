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

// ── Action state (result of a single booking attempt) ─────────────────────────

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

// ── Per-card loading state (tracks which class IDs are in flight) ─────────────

/// Holds the set of class IDs whose booking request is currently in flight.
/// UI layers use this to disable individual Book buttons while the request runs.
class BookingInFlightNotifier extends StateNotifier<Set<String>> {
  BookingInFlightNotifier() : super(const <String>{});

  void markInFlight(String classId) {
    state = {...state, classId};
  }

  void markCompleted(String classId) {
    state = {...state}..remove(classId);
  }

  bool isInFlight(String classId) => state.contains(classId);
}

final bookingInFlightProvider =
    StateNotifierProvider<BookingInFlightNotifier, Set<String>>((ref) {
  return BookingInFlightNotifier();
});

// ── Booking notifier ──────────────────────────────────────────────────────────

class BookingNotifier extends StateNotifier<BookingActionState> {
  final IBookingRepository _repository;
  final Ref _ref;

  BookingNotifier(this._repository, this._ref) : super(const BookingActionIdle());

  Future<void> bookClass(String classId) async {
    _ref.read(bookingInFlightProvider.notifier).markInFlight(classId);
    state = const BookingActionLoading();
    try {
      final booking = await _repository.createBooking(classId);
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
    } finally {
      _ref.read(bookingInFlightProvider.notifier).markCompleted(classId);
    }
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingActionState>((ref) {
  return BookingNotifier(ref.read(bookingRepositoryProvider), ref);
});

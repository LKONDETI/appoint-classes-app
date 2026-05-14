import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appt_app/features/booking/domain/entities/booking_entity.dart';
import 'package:appt_app/features/booking/domain/repositories/i_booking_repository.dart';
import 'package:appt_app/features/bookings/presentation/providers/my_bookings_provider.dart';

class MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late MockBookingRepository mockRepository;

  final testBookings = [
    BookingEntity(
      id: 'booking-1',
      classId: 'class-1',
      classTitle: 'Yoga Flow',
      scheduledAt: DateTime(2026, 6, 1, 10),
      bookedAt: DateTime(2026, 5, 20, 9),
      status: 'Confirmed',
    ),
    BookingEntity(
      id: 'booking-2',
      classId: 'class-2',
      classTitle: 'HIIT Blast',
      scheduledAt: DateTime(2026, 6, 3, 18),
      bookedAt: DateTime(2026, 5, 21, 11),
      status: 'Cancelled',
    ),
  ];

  setUp(() {
    mockRepository = MockBookingRepository();
  });

  ProviderContainer buildContainer() {
    return ProviderContainer(
      overrides: [
        myBookingsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  }

  group('MyBookingsNotifier', () {
    test('initial state is MyBookingsInitial', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      expect(container.read(myBookingsProvider), isA<MyBookingsInitial>());
    });

    test('loadMyBookings transitions to MyBookingsLoaded on success', () async {
      when(() => mockRepository.getMyBookings())
          .thenAnswer((_) async => testBookings);

      final container = buildContainer();
      addTearDown(container.dispose);

      await container.read(myBookingsProvider.notifier).loadMyBookings();

      final state = container.read(myBookingsProvider);
      expect(state, isA<MyBookingsLoaded>());
      final loaded = state as MyBookingsLoaded;
      expect(loaded.bookings.length, 2);
      expect(loaded.bookings.first.classTitle, 'Yoga Flow');
      expect(loaded.bookings.last.status, 'Cancelled');
    });

    test('loadMyBookings transitions to MyBookingsLoading then to loaded', () async {
      when(() => mockRepository.getMyBookings())
          .thenAnswer((_) async => testBookings);

      final container = buildContainer();
      addTearDown(container.dispose);

      final states = <MyBookingsState>[];
      container.listen<MyBookingsState>(
        myBookingsProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      await container.read(myBookingsProvider.notifier).loadMyBookings();

      expect(states, [
        isA<MyBookingsInitial>(),
        isA<MyBookingsLoading>(),
        isA<MyBookingsLoaded>(),
      ]);
    });

    test('loadMyBookings transitions to MyBookingsError on exception', () async {
      when(() => mockRepository.getMyBookings())
          .thenThrow(Exception('Network error'));

      final container = buildContainer();
      addTearDown(container.dispose);

      await container.read(myBookingsProvider.notifier).loadMyBookings();

      final state = container.read(myBookingsProvider);
      expect(state, isA<MyBookingsError>());
      final error = state as MyBookingsError;
      expect(error.message, contains('Network error'));
    });

    test('loadMyBookings with empty list produces MyBookingsLoaded with empty list', () async {
      when(() => mockRepository.getMyBookings())
          .thenAnswer((_) async => []);

      final container = buildContainer();
      addTearDown(container.dispose);

      await container.read(myBookingsProvider.notifier).loadMyBookings();

      final state = container.read(myBookingsProvider);
      expect(state, isA<MyBookingsLoaded>());
      expect((state as MyBookingsLoaded).bookings, isEmpty);
    });
  });
}

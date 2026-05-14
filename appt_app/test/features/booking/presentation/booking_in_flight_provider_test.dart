import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appt_app/features/booking/presentation/providers/booking_provider.dart';

void main() {
  ProviderContainer buildContainer() => ProviderContainer();

  group('BookingInFlightNotifier', () {
    test('initial state is an empty set', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      expect(container.read(bookingInFlightProvider), isEmpty);
    });

    test('markInFlight adds classId to the set', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      container.read(bookingInFlightProvider.notifier).markInFlight('class-1');

      expect(container.read(bookingInFlightProvider), contains('class-1'));
    });

    test('markCompleted removes classId from the set', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(bookingInFlightProvider.notifier);
      notifier.markInFlight('class-1');
      notifier.markCompleted('class-1');

      expect(container.read(bookingInFlightProvider), isNot(contains('class-1')));
    });

    test('multiple class IDs can be in flight simultaneously', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(bookingInFlightProvider.notifier);
      notifier.markInFlight('class-1');
      notifier.markInFlight('class-2');
      notifier.markInFlight('class-3');

      final state = container.read(bookingInFlightProvider);
      expect(state, containsAll(['class-1', 'class-2', 'class-3']));
      expect(state.length, 3);
    });

    test('completing one in-flight ID does not affect others', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(bookingInFlightProvider.notifier);
      notifier.markInFlight('class-1');
      notifier.markInFlight('class-2');
      notifier.markCompleted('class-1');

      final state = container.read(bookingInFlightProvider);
      expect(state, isNot(contains('class-1')));
      expect(state, contains('class-2'));
    });

    test('isInFlight returns true for an in-flight classId', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(bookingInFlightProvider.notifier);
      notifier.markInFlight('class-42');

      expect(notifier.isInFlight('class-42'), isTrue);
    });

    test('isInFlight returns false for a classId not in flight', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final notifier = container.read(bookingInFlightProvider.notifier);

      expect(notifier.isInFlight('class-99'), isFalse);
    });

    test('markCompleted on unknown classId does not throw', () {
      final container = buildContainer();
      addTearDown(container.dispose);

      expect(
        () => container
            .read(bookingInFlightProvider.notifier)
            .markCompleted('non-existent'),
        returnsNormally,
      );
    });
  });
}

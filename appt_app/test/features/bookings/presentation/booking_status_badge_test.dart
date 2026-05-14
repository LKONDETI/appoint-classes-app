import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appt_app/features/bookings/presentation/widgets/booking_status_badge.dart';

Widget buildBadge(String status) {
  return MaterialApp(
    home: Scaffold(
      body: BookingStatusBadge(status: status),
    ),
  );
}

void main() {
  group('BookingStatusBadge', () {
    testWidgets('displays "Confirmed" label for confirmed status', (tester) async {
      await tester.pumpWidget(buildBadge('confirmed'));
      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('displays "Cancelled" label for cancelled status', (tester) async {
      await tester.pumpWidget(buildBadge('cancelled'));
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('is case-insensitive for confirmed status', (tester) async {
      await tester.pumpWidget(buildBadge('Confirmed'));
      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('is case-insensitive for cancelled status', (tester) async {
      await tester.pumpWidget(buildBadge('CANCELLED'));
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('renders raw status text for unknown status values', (tester) async {
      await tester.pumpWidget(buildBadge('Pending'));
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('renders green background for confirmed status', (tester) async {
      await tester.pumpWidget(buildBadge('confirmed'));
      await tester.pump();

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(const Color(0xFFD4EDDA)));
    });

    testWidgets('renders red background for cancelled status', (tester) async {
      await tester.pumpWidget(buildBadge('cancelled'));
      await tester.pump();

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(const Color(0xFFF8D7DA)));
    });
  });
}

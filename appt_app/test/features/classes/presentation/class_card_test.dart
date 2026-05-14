import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appt_app/features/classes/domain/entities/class_entity.dart';
import 'package:appt_app/features/classes/presentation/widgets/class_card.dart';

ClassEntity buildEntity({
  String id = 'class-1',
  String title = 'Yoga Flow',
  String providerName = 'Jane Doe',
  String? providerAvatarUrl,
  bool isFull = false,
}) {
  return ClassEntity(
    id: id,
    title: title,
    providerName: providerName,
    providerAvatarUrl: providerAvatarUrl,
    scheduledAt: DateTime(2026, 6, 1, 10),
    durationMinutes: 60,
    maxCapacity: isFull ? 10 : 10,
    bookedCount: isFull ? 10 : 2,
  );
}

Widget buildTestWidget({
  required ClassEntity entity,
  VoidCallback? onBook,
  bool isLoading = false,
}) {
  return MaterialApp(
    home: Scaffold(
      body: ClassCard(
        entity: entity,
        onBook: onBook,
        isLoading: isLoading,
      ),
    ),
  );
}

void main() {
  group('ClassCard — provider avatar', () {
    testWidgets('renders CircleAvatar with two initials for a two-word name', (tester) async {
      await tester.pumpWidget(buildTestWidget(entity: buildEntity(providerName: 'Jane Doe')));

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar with single initial for a one-word name', (tester) async {
      await tester.pumpWidget(buildTestWidget(entity: buildEntity(providerName: 'Madonna')));

      expect(find.text('M'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar with fallback ? for an empty provider name', (tester) async {
      await tester.pumpWidget(buildTestWidget(entity: buildEntity(providerName: '')));

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar with initials from first and last part of multi-word name', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(entity: buildEntity(providerName: 'Mary Jo Smith')),
      );

      // First word 'M' + last word 'S'
      expect(find.text('MS'), findsOneWidget);
    });
  });

  group('ClassCard — book button', () {
    testWidgets('Book button is enabled and calls onBook when not loading and not full', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildTestWidget(entity: buildEntity(), onBook: () => tapped = true),
      );

      final bookButton = find.widgetWithText(FilledButton, 'Book');
      expect(bookButton, findsOneWidget);
      await tester.tap(bookButton);
      expect(tapped, isTrue);
    });

    testWidgets('Book button shows spinner and is disabled when isLoading is true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          entity: buildEntity(),
          onBook: () {},
          isLoading: true,
        ),
      );

      // Should have a CircularProgressIndicator inside the button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // The button text 'Book' should not be visible
      expect(find.text('Book'), findsNothing);

      // The FilledButton should be disabled (onPressed is null when isLoading)
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Book button shows Full and is disabled when class is full', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(entity: buildEntity(isFull: true), onBook: () {}),
      );

      expect(find.text('Full'), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('class title and provider name are displayed', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          entity: buildEntity(title: 'Morning Pilates', providerName: 'Alice'),
        ),
      );

      expect(find.text('Morning Pilates'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
    });
  });
}

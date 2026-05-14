import 'package:flutter/material.dart';

/// Displays a coloured pill badge for a booking status value.
///
/// Recognised values (case-insensitive): `confirmed`, `cancelled`.
/// Any other value renders as a neutral grey badge.
class BookingStatusBadge extends StatelessWidget {
  final String status;

  const BookingStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final normalised = status.toLowerCase();

    final (Color background, Color foreground, String label) = switch (normalised) {
      'confirmed' => (
          const Color(0xFFD4EDDA),
          const Color(0xFF155724),
          'Confirmed',
        ),
      'cancelled' => (
          const Color(0xFFF8D7DA),
          const Color(0xFF721C24),
          'Cancelled',
        ),
      _ => (
          const Color(0xFFE2E3E5),
          const Color(0xFF383D41),
          status,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

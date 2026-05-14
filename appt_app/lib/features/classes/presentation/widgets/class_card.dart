import 'package:flutter/material.dart';
import '../../domain/entities/class_entity.dart';

class ClassCard extends StatelessWidget {
  final ClassEntity entity;

  /// Called when the user taps the Book button.
  /// Null means the button is permanently disabled (e.g. class is full).
  final VoidCallback? onBook;

  /// When true the Book button shows a loading spinner and is non-interactive.
  /// Use this to reflect that a booking request for THIS card is in flight.
  final bool isLoading;

  const ClassCard({
    super.key,
    required this.entity,
    this.onBook,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isButtonDisabled = entity.isFull || isLoading;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ProviderAvatar(
              providerName: entity.providerName,
              avatarUrl: entity.providerAvatarUrl,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entity.providerName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDateTime(entity.scheduledAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: isButtonDisabled ? null : onBook,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(entity.isFull ? 'Full' : 'Book'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${months[dt.month - 1]} ${dt.day}  •  $hour:$minute $period';
  }
}

/// A [CircleAvatar] that shows the provider's network image when available,
/// or falls back to the provider's initials derived from their display name.
class _ProviderAvatar extends StatelessWidget {
  final String providerName;
  final String? avatarUrl;

  const _ProviderAvatar({required this.providerName, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initials = _extractInitials(providerName);

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: colorScheme.primaryContainer,
        // Show initials while the image loads or on error.
        child: null,
      );
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Returns up to two uppercase initials from [name].
  /// Examples: "Jane Doe" → "JD", "Alice" → "A", "" → "?"
  String _extractInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

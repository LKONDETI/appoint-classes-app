import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/my_bookings_provider.dart';
import '../widgets/booking_status_badge.dart';
import '../../../booking/domain/entities/booking_entity.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myBookingsProvider.notifier).loadMyBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingsState = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: false,
      ),
      body: switch (bookingsState) {
        MyBookingsInitial() || MyBookingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        MyBookingsLoaded(:final bookings) when bookings.isEmpty =>
          const Center(
            child: Text('You have no bookings yet.'),
          ),
        MyBookingsLoaded(:final bookings) => RefreshIndicator(
            onRefresh: () =>
                ref.read(myBookingsProvider.notifier).loadMyBookings(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: bookings.length,
              itemBuilder: (context, index) =>
                  _BookingListItem(booking: bookings[index]),
            ),
          ),
        MyBookingsError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      ref.read(myBookingsProvider.notifier).loadMyBookings(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
      },
    );
  }
}

class _BookingListItem extends StatelessWidget {
  final BookingEntity booking;

  const _BookingListItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.classTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                BookingStatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDateTime(booking.scheduledAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Booked ${_formatDateTime(booking.bookedAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '${months[dateTime.month - 1]} ${dateTime.day}  •  $hour:$minute $period';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../classes/presentation/providers/class_provider.dart';
import '../../../classes/presentation/widgets/class_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(classProvider.notifier).loadClasses(limit: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final classState = ref.watch(classProvider);

    ref.listen<BookingActionState>(bookingProvider, (_, next) {
      switch (next) {
        case BookingActionSuccess():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Class booked successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        case BookingActionError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        default:
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('ApptClass'),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Classes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),
          switch (classState) {
            ClassInitial() || ClassLoading() => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ClassLoaded(:final classes) when classes.isEmpty =>
              const SliverFillRemaining(
                child: Center(child: Text('No upcoming classes.')),
              ),
            ClassLoaded(:final classes) => SliverList.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final entity = classes[index];
                  return ClassCard(
                    entity: entity,
                    onBook: () =>
                        ref.read(bookingProvider.notifier).bookClass(entity.id),
                  );
                },
              ),
            ClassError(:final message) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => ref
                            .read(classProvider.notifier)
                            .loadClasses(limit: 5),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
          },
        ],
      ),
    );
  }
}

class ClassEntity {
  final String id;
  final String title;
  final String providerName;
  final String? providerAvatarUrl;
  final String? providerSpecialty;
  final DateTime scheduledAt;
  final int durationMinutes;
  final int maxCapacity;
  final int bookedCount;
  final String? description;

  const ClassEntity({
    required this.id,
    required this.title,
    required this.providerName,
    this.providerAvatarUrl,
    this.providerSpecialty,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.maxCapacity,
    required this.bookedCount,
    this.description,
  });

  bool get isFull => bookedCount >= maxCapacity;
}

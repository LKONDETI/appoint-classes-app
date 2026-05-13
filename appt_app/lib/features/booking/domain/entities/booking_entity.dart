class BookingEntity {
  final String id;
  final String classId;
  final String classTitle;
  final DateTime scheduledAt;
  final DateTime bookedAt;
  final String status;

  const BookingEntity({
    required this.id,
    required this.classId,
    required this.classTitle,
    required this.scheduledAt,
    required this.bookedAt,
    required this.status,
  });
}

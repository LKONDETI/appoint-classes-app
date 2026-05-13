import '../entities/class_entity.dart';

abstract interface class IClassRepository {
  Future<List<ClassEntity>> getUpcoming({int limit = 10});
}

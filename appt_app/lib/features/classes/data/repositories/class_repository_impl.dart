import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/i_class_repository.dart';
import '../datasources/class_remote_datasource.dart';
import '../models/class_model.dart';

class ClassRepositoryImpl implements IClassRepository {
  final ClassRemoteDataSource _remote;

  const ClassRepositoryImpl(this._remote);

  @override
  Future<List<ClassEntity>> getUpcoming({int limit = 10}) async {
    final models = await _remote.getUpcoming(limit);
    return models.map(_toEntity).toList();
  }

  ClassEntity _toEntity(ClassModel m) => ClassEntity(
        id: m.id,
        title: m.title,
        providerName: m.provider.name,
        providerAvatarUrl: m.provider.avatarUrl,
        providerSpecialty: m.provider.specialty,
        scheduledAt: m.scheduledAt,
        durationMinutes: m.durationMinutes,
        maxCapacity: m.maxCapacity,
        bookedCount: m.bookedCount,
        description: m.description,
      );
}

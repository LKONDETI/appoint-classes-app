import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/class_remote_datasource.dart';
import '../../data/repositories/class_repository_impl.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/i_class_repository.dart';

final classRepositoryProvider = Provider<IClassRepository>((ref) {
  return ClassRepositoryImpl(
    ClassRemoteDataSource(ref.read(dioProvider)),
  );
});

sealed class ClassState {
  const ClassState();
}

class ClassInitial extends ClassState {
  const ClassInitial();
}

class ClassLoading extends ClassState {
  const ClassLoading();
}

class ClassLoaded extends ClassState {
  final List<ClassEntity> classes;
  const ClassLoaded(this.classes);
}

class ClassError extends ClassState {
  final String message;
  const ClassError(this.message);
}

class ClassNotifier extends StateNotifier<ClassState> {
  final IClassRepository _repo;

  ClassNotifier(this._repo) : super(const ClassInitial());

  Future<void> loadClasses({int limit = 10}) async {
    state = const ClassLoading();
    try {
      final classes = await _repo.getUpcoming(limit: limit);
      state = ClassLoaded(classes);
    } on Exception catch (e) {
      state = ClassError(e.toString());
    }
  }
}

final classProvider = StateNotifierProvider<ClassNotifier, ClassState>((ref) {
  return ClassNotifier(ref.read(classRepositoryProvider));
});

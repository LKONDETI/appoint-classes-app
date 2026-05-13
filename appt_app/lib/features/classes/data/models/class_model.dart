import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_model.freezed.dart';
part 'class_model.g.dart';

@freezed
abstract class ProviderModel with _$ProviderModel {
  const factory ProviderModel({
    required String id,
    required String name,
    String? avatarUrl,
    String? specialty,
  }) = _ProviderModel;

  factory ProviderModel.fromJson(Map<String, dynamic> json) =>
      _$ProviderModelFromJson(json);
}

@freezed
abstract class ClassModel with _$ClassModel {
  const factory ClassModel({
    required String id,
    required String title,
    required ProviderModel provider,
    required DateTime scheduledAt,
    required int durationMinutes,
    required int maxCapacity,
    required int bookedCount,
    String? description,
  }) = _ClassModel;

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);
}

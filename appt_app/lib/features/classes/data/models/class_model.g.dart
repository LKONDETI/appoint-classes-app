// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderModel _$ProviderModelFromJson(Map<String, dynamic> json) =>
    _ProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      specialty: json['specialty'] as String?,
    );

Map<String, dynamic> _$ProviderModelToJson(_ProviderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'specialty': instance.specialty,
    };

_ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => _ClassModel(
  id: json['id'] as String,
  title: json['title'] as String,
  provider: ProviderModel.fromJson(json['provider'] as Map<String, dynamic>),
  scheduledAt: DateTime.parse(json['scheduledAt'] as String),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  maxCapacity: (json['maxCapacity'] as num).toInt(),
  bookedCount: (json['bookedCount'] as num).toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$ClassModelToJson(_ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'provider': instance.provider,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'maxCapacity': instance.maxCapacity,
      'bookedCount': instance.bookedCount,
      'description': instance.description,
    };

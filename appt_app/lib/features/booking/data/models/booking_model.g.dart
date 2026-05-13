// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingModel _$BookingModelFromJson(Map<String, dynamic> json) =>
    _BookingModel(
      id: json['id'] as String,
      classId: json['classId'] as String,
      classTitle: json['classTitle'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      bookedAt: DateTime.parse(json['bookedAt'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$BookingModelToJson(_BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classId': instance.classId,
      'classTitle': instance.classTitle,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'bookedAt': instance.bookedAt.toIso8601String(),
      'status': instance.status,
    };

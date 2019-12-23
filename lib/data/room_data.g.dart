// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Create_room_Response _$Create_room_ResponseFromJson(Map<String, dynamic> json) {
  return Create_room_Response(
    json['titlt'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$Create_room_ResponseToJson(
        Create_room_Response instance) =>
    <String, dynamic>{
      'titlt': instance.uname,
      'id': instance.room_id,
    };

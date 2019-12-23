// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserRoomsResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRoomResponse _$UserRoomResponseFromJson(Map<String, dynamic> json) {
  return UserRoomResponse(
    json['pk'] as int,
    json['fields'] == null
        ? null
        : Room_Fields.fromJson(json['fields'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserRoomResponseToJson(UserRoomResponse instance) =>
    <String, dynamic>{
      'pk': instance.id,
      'fields': instance.data,
    };

Room_Fields _$Room_FieldsFromJson(Map<String, dynamic> json) {
  return Room_Fields(
    json['title'] as String,
    json['date'] as String,
    json['time'] as String,
    json['location_address'] as String,
    json['subject'] as String,
    json['priority'] as String,
  );
}

Map<String, dynamic> _$Room_FieldsToJson(Room_Fields instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date,
      'time': instance.time,
      'location_address': instance.location_address,
      'subject': instance.subject,
      'priority': instance.priority,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'user_list_response.dart';
// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
UserListResponse _$UserListResponseFromJson(Map<String, dynamic> json) {
  return UserListResponse(
    json['pk'] as int,
    json['fields'] == null
        ? null
        : Fields.fromJson(json['fields'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserListResponseToJson(UserListResponse instance) =>
    <String, dynamic>{
      'pk': instance.id,
      'fields': instance.data,
    };

Fields _$FieldsFromJson(Map<String, dynamic> json) {
  return Fields(
    json['Name'] as String,
    json['Username'] as String,
    json['Mobile_Number'] as String,
  );
}

Map<String, dynamic> _$FieldsToJson(Fields instance) => <String, dynamic>{
      'Name': instance.name,
      'Username': instance.user_name,
      'Mobile_Number': instance.phone,
    };

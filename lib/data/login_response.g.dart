// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    json['username'] as String,
    json['name'] as String,
    json['Mobile_Number'] as String,
    json['position'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'username': instance.uname,
      'name': instance.full_name,
      'Mobile_Number': instance.phone,
      'position': instance.joptitle,
    };

import 'package:json_annotation/json_annotation.dart';
import 'login_response.dart';
part 'user_list_response.g.dart';

@JsonSerializable()
class UserListResponse {
  @JsonKey(name: 'pk')
  int id;
  @JsonKey(name: 'fields')
  Fields data;
  UserListResponse(this.id, this.data);
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UserListResponse.fromJson(Map<String, dynamic> json) => _$UserListResponseFromJson(json);
  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserListResponseToJson(this);
}
@JsonSerializable()
class Fields {
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Username')
  String user_name;
  @JsonKey(name: 'Mobile_Number')
  String phone;
  Fields(this.name, this.user_name, this.phone);
  factory Fields.fromJson(Map<String, dynamic> json) => _$FieldsFromJson(json);
  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FieldsToJson(this);



}

Fields dummy_fields() => Fields(dummy_string, dummy_string, dummy_string);

import 'package:json_annotation/json_annotation.dart';
part 'room_data.g.dart';
@JsonSerializable()
class Create_room_Response {
  @JsonKey(name: 'titlt')
  String uname;
  @JsonKey(name: 'id')
  int room_id;
  Create_room_Response(this.uname, this.room_id);
  factory Create_room_Response.fromJson(Map<String, dynamic> json) => _$Create_room_ResponseFromJson(json);
  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$Create_room_ResponseToJson(this);
}
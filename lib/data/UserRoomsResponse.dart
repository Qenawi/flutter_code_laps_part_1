

import 'package:json_annotation/json_annotation.dart';
part 'UserRoomsResponse.g.dart';

@JsonSerializable()
class UserRoomResponse {
  @JsonKey(name: 'pk')
  int id;
  @JsonKey(name: 'fields')
  Room_Fields data;
  UserRoomResponse(this.id, this.data);
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UserRoomResponse.fromJson(Map<String, dynamic> json) => _$UserRoomResponseFromJson(json);
  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserRoomResponseToJson(this);
}



@JsonSerializable()
class Room_Fields {
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'date')
  String date;
  @JsonKey(name: 'time')
  String time;
  @JsonKey(name: 'location_address')
  String location_address;
  @JsonKey(name: 'subject')
  String subject;
  @JsonKey(name: 'priority')
  String priority;
  Room_Fields(this.title, this.date, this.time,this.location_address,this.subject,this.priority);
  factory Room_Fields.fromJson(Map<String, dynamic> json) => _$Room_FieldsFromJson(json);
  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$Room_FieldsToJson(this);
}
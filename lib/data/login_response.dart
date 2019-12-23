import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';
final dummy_phone = "phone";
final dummy_string = "string";
final dummy_int = 0;
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'username')
  String uname;
  @JsonKey(name: 'name')
  String full_name;
  @JsonKey(name: 'Mobile_Number')
  String phone;
  @JsonKey(name: 'position')
  String joptitle;
  LoginResponse(this.uname, this.full_name, this.phone, this.joptitle);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

}

LoginResponse dummy_login_response() =>
    LoginResponse(dummy_string, dummy_string, dummy_phone, dummy_string);

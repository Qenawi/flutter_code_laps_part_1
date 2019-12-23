import 'dart:io';
import 'package:flutter_code_laps_part_1/data/login_response.dart';
import 'package:flutter_code_laps_part_1/data/room_data.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'network_layer.g.dart';

const _login = "api/login/";
const _register = "api/register/";
const _user_list = "api/list/";
const _api_base = "http://192.168.1.221:1994/";
const _new_room = "api/new/";
const _meeting = "api/meeting/";
const _logOut = "api/logout/";
@RestApi(baseUrl: _api_base)
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST(_login)
  Future<LoginResponse> m_login(@Body() Map<String, dynamic> data);

  @POST(_new_room)
  Future<Create_room_Response> m_create_room(@Body() Map<String, dynamic> data);

  @POST(_register)
  Future<LoginResponse> m_register(@Body() Map<String, dynamic> data);

  @GET(_user_list)
  Future<String> m_user_list();

  @POST(_meeting)
  Future<String> m_user_meetings(@Body() Map<String, dynamic> data);

  @POST(_logOut)
  Future<String> m_log_out(@Body() Map<String, dynamic> data);
}

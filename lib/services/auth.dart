import 'dart:convert';
import 'package:flutter_user/common/HttpHelper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_user/models/auth.dart';

class AuthService {
  AuthService._instantiate();
  static final AuthService instance = AuthService._instantiate();

  Future<AuthResponse> authenticate(
      {required String username, required String password}) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    return http
        .post(
      Uri.parse(baseUrl + '/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    )
        .then((value) async {
      final storage = new FlutterSecureStorage();
      dynamic res = jsonDecode(value.body);
      AuthResponse auth = AuthResponse.fromJson(res);
      await storage.write(key: 'token', value: auth.user.token);
      await storage.write(key: 'expired', value: auth.user.tokenExpiredTime);
      await storage.write(key: 'userId', value: auth.user.id);
      return auth;
    });
  }

  Future<bool> tryAutoLogin() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final expired = await storage.read(key: 'expired');
    if (token != null || token != '' && expired != '') {
      if (DateTime.parse(expired.toString())
          .toUtc()
          .isAfter(DateTime.now().toUtc())) {
        return true;
      }
    }
    return false;
  }
}

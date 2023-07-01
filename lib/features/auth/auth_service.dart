import 'dart:convert';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_model.dart';

class AuthService {
  AuthService._instantiate();

  static final AuthService instance = AuthService._instantiate();

  final storage = new FlutterSecureStorage();

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
      dynamic res = jsonDecode(value.body);
      AuthResponse auth = AuthResponse.fromJson(res);
      await storage.write(key: 'token', value: auth.user?.token);
      await storage.write(key: 'expired', value: auth.user?.tokenExpiredTime);
      await storage.write(key: 'userId', value: auth.user?.id);
      return auth;
    });
  }

  Future<bool> logout() async {
    try {
      await storage.deleteAll();
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> tryAutoLogin() async {
    final token = await storage.read(key: 'token');
    final expired = await storage.read(key: 'expired');
    if (token != null && expired != null) {
      if (DateTime.parse(expired.toString())
          .toUtc()
          .isAfter(DateTime.now().toUtc())) {
        return true;
      }
    }
    return false;
  }

  Future<int> isChangePassword(
      {required String username,
      required String password,
      required String currentPassword}) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final res = await http.post(
      Uri.parse(baseUrl + '/password/change'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'currentPassword': currentPassword,
      }),
    );
    if (res.statusCode != 200) {
      throw json.decode(res.body)['error']['message'];
    }
    return int.parse(res.body);
  }

  Future<AuthResponse> signup({
    required String username,
    required String password,
    required String contact,
    required String firstName,
    required String lastName,
  }) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final res = await http.post(
      Uri.parse(baseUrl + '/signup/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "contact": contact,
        "firstName": firstName,
        "lastName": lastName,
      }),
    );
    if (res.statusCode != 200) {
      throw json.decode(res.body)['error']['message'];
    }

    dynamic resBody = jsonDecode(res.body);
    return AuthResponse.fromJson(resBody);
  }

  Future<bool> sendEmailForgotPW({required String contact}) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final res = await http.post(
      Uri.parse(baseUrl + '/password/forgot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "contact": contact,
      }),
    );
    if (res.statusCode != 200) {
      throw json.decode(res.body)['error']['message'];
    }

    if (jsonDecode(res.body).toString() == 'true') {
      return true;
    }
    return false;
  }

  Future<int> resetPassword({
    required String username,
    required String passcode,
    required String password,
  }) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final res = await http.post(
      Uri.parse(baseUrl + '/password/reset'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "passcode": passcode,
        "password": password,
      }),
    );
    if (res.statusCode != 200) {
      throw json.decode(res.body)['error']['message'];
    }

    dynamic resBody = jsonDecode(res.body);
    return int.parse(resBody.toString());
  }
}

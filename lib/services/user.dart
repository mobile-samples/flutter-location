import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/HttpHelper.dart';
import 'package:flutter_user/models/search.dart';
import 'package:flutter_user/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  UserService._instantiate();
  static final UserService instance = UserService._instantiate();
  final storage = new FlutterSecureStorage();

  Future<List<UserInfo>> searchUser(Filter filter) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(Uri.parse(baseUrl + '/users/search'),
        headers: headers, body: jsonEncode(filter));
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      SearchResult<UserInfo> searchRes = SearchResult.fromJson(res);
      return searchRes.list;
    } else {
      throw json.decode(response.body)['error'];
    }
  }

  Future<UserInfo> getUserInfo(String userId) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.get(
      Uri.parse(baseUrl + '/my-profile/' + (userId ?? '')),
      headers: headers,
    );
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      UserInfo userInfo = UserInfo.fromJson(res);
      return userInfo;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<String>> getSkills(String keyword) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final response = await http
        .get(Uri.parse(baseUrl + '/skills?keyword=' + keyword + '&max=20'));
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      List<String> listSkills = List<String>.from(res.map((e) => e.toString()));
      return listSkills;
    } else {
      throw json.decode(response.body)['error'];
    }
  }

  Future<SaveResult<UserInfo>> saveInfo(UserInfo userInfo) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.patch(
      Uri.parse(baseUrl + '/my-profile/' + (userInfo.id ?? '')),
      headers: headers,
      body: jsonEncode(userInfo),
    );
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      SaveResult<UserInfo> saveRes = SaveResult<UserInfo>.fromJson(res);
      return saveRes;
    } else {
      throw json.decode(response.body)['error'];
    }
  }
}

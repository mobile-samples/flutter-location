import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:flutter_user/features/comment/reaction.dart';
import 'package:http/http.dart' as http;

class ReactionCommentClient implements ReactionService {
  ReactionCommentClient._instantiate();

  static final ReactionService instance = ReactionCommentClient._instantiate();
  String url = HttpHelper.instance.getUrl() + "/films";

  ReactionCommentClient(this.url);

  @override
  Future<int> removeUseful(String id, String author, String? userId) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.delete(
        Uri.parse('$url/commentthread/$id/$author/useful/${userId ?? ''}'),
        headers: headers);
    if (response.statusCode == 200 && json.decode(response.body) > 0) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> setUseful(String id, String author, String? userId) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();

    final response = await http.post(
        Uri.parse('$url/commentthread/$id/$author/useful/${userId ?? ''}'),
        headers: headers,
        body: jsonEncode(<dynamic, dynamic>{}));
    if (response.statusCode == 200 && json.decode(response.body) > 0) {
      return 1;
    } else {
      print(json.decode(response.body));
      throw json.decode(response.body)['error']['message'];
    }
  }
}

class ReactionRateClient implements ReactionService {
  ReactionRateClient._instantiate();

  static final ReactionService instance = ReactionRateClient._instantiate();
  static final String name = "films";
  String url = HttpHelper.instance.getUrl() + "/" + name;

  @override
  Future<int> removeUseful(String id, String author, String? userId) async {
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.delete(
        Uri.parse('$url/rates/$id/$author/useful/${userId ?? ''}'),
        headers: headers);
    if (response.statusCode == 200 && json.decode(response.body) > 0) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> setUseful(String id, String author, String? userId) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();

    final response = await http.post(
        Uri.parse('$url/rates/$id/$author/useful/${userId ?? ''}'),
        headers: headers,
        body: jsonEncode(<dynamic, dynamic>{}));
    if (response.statusCode == 200 && json.decode(response.body) > 0) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

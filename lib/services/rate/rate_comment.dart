import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/HttpHelper.dart';
import 'package:flutter_user/models/rate.dart';
import 'package:http/http.dart' as http;

abstract class RateService {
  Future<int> postRate(String id, int rate, String review, String time,
      bool anonymous);
}

abstract class RateCommentService {
  Future<List<RateReply>> getComments(
      String locationId, String authorOfRate);
  Future<int> comment(String id, String authorOfRate, String comment,
      String time, bool anonymous);
  Future<int> delete(String commentThreadId, String commentId, String author);
  Future<int> update(String commentId, String comment, String author);
}

class RateClient implements RateService  {
  RateClient._instantiate();
  late String url = HttpHelper.instance.getUrl() + "/films";

  RateClient(this.url);

  static final RateClient instance = RateClient._instantiate();

  Future<int> postRate(String id, int rate, String review, String time,
      bool anonymous) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse( '$url/rates/$id/${userId ?? ''}'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'rate': rate,
        'review': review,
        'time': time,
        'anonymous': anonymous
      }),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

class RateReplyClient implements RateCommentService {
  RateReplyClient._instantiate();
  static final RateReplyClient instance = RateReplyClient._instantiate();
  late String url = HttpHelper.instance.getUrl() + "/films";

  RateReplyClient(this.url);

  Future<List<RateReply>> getComments(
      String locationId, String authorOfRate) async {
    final response = await http.get(Uri.parse('$url/rates/$locationId/$authorOfRate/comments'));
    if (response.statusCode == 200) {
      dynamic data =  jsonDecode(response.body);
      if (data ==null){
        return List.empty();
      }
      List<RateReply> listReply = List<RateReply>.from(
          jsonDecode(response.body).map((x) => RateReply.fromJson(x)));
      return listReply;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<int> comment(String id, String authorOfRate, String comment,
      String time, bool anonymous) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();

    final response = await http.post(
      Uri.parse('$url/rates/$id/$authorOfRate/comments/${userId ?? ''}'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'comment': comment,
        'time': time,
        'anonymous': anonymous
      }),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> delete(String commentThreadId, String commentId, String author) async {
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.delete(Uri.parse("$url/rates/$commentThreadId/comments/$commentId/$author"),
      headers: headers,
      body: jsonEncode(
          <String, dynamic>{}),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  Future<int> update(String commentId, String comment, String author) async {
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.patch( Uri.parse('$url/rates/comments/$commentId/$author'),
      headers: headers,
      body: jsonEncode(
          <String, dynamic>{'comment' : comment}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

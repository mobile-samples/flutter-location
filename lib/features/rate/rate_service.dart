import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:flutter_user/features/rate/rate_model.dart';
import 'package:http/http.dart' as http;

class RateService {
  RateService._instantiate();

  static final RateService instance = RateService._instantiate();

  Future<SearchResult<RateComment>> search(
      String url, String id, String sort) async {
    const storage = FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse(baseUrl + url),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'limit': 24,
        'sort': sort,
        'userId': userId
      }),
    );
    if (response.statusCode == 200) {
      dynamic res = jsonDecode(response.body);
      SearchResult<RateComment> searchResult = SearchResult.fromJson(res);
      return searchResult;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<RateReply>> getReplyofRate(
      String serviceName, String id, String authorOfRate) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final response = await http.get(
      Uri.parse('$baseUrl/$serviceName/rates/$id/$authorOfRate/comments'),
    );
    if (response.statusCode == 200) {
      List<RateReply> listReply = [];
      if (jsonDecode(response.body) != null) {
        listReply = List<RateReply>.from(
          jsonDecode(response.body).map((x) => RateReply.fromJson(x)),
        );
      }
      return listReply;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<int> postRate(String locationId, int rate, String review, String time,
      bool anonymous) async {
    const storage = FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse(
          '$baseUrl/locations/rates/$locationId/${userId ?? ''}'),
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

  Future<int> postUseful(
      String serviceName, String id, String authorOfRate, bool useful) async {
    const storage = FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final url = '$baseUrl/$serviceName/rates/$id/$authorOfRate/useful/${userId ?? ''}';
    final response = useful
        ? await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(<dynamic, dynamic>{}))
        : await http.delete(Uri.parse(url), headers: headers);
    if (response.statusCode == 200 && json.decode(response.body) > 0) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<int> postReply(String serviceName, String id, String authorOfRate,
      String comment, String time, bool anonymous) async {
    const storage = FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse('$baseUrl/$serviceName/rates/$id/$authorOfRate/comments/${userId ?? ''}'),
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
}

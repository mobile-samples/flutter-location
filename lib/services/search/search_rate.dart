import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/HttpHelper.dart';
import 'package:flutter_user/models/rate.dart';
import 'package:flutter_user/models/search.dart';
import 'package:http/http.dart' as http;

abstract class SearchRateService<RateComment> {
  Future<SearchResult<RateComment>> search(String id);
}

class SearchRateClient implements SearchRateService<RateComment> {
  SearchRateClient._instantiate();

  static final SearchRateClient instance = SearchRateClient
      ._instantiate();
  final String name = "films";

  Future<SearchResult<RateComment>> search(String id) async {
    final storage = new FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse(baseUrl + '/'+name+'/rates/search'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'limit': 24,
        'sort': '-time',
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
}

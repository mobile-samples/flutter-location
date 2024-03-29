import 'dart:convert';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:http/http.dart' as http;

import 'film_model.dart';

class FilmService {
  FilmService._instantiate();

  static final FilmService instance = FilmService._instantiate();

  Future<SearchResult<Film>> search() async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/films/search?limit=24'));
    if (response.statusCode == 200) {
      dynamic res = HttpHelper.instance.jsonDecode(response.bodyBytes);
      SearchResult<Film> searchResult = SearchResult.fromJson(res);
      return searchResult;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<Film> get(String id) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.get(
      Uri.parse('$baseUrl/films/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      dynamic res = HttpHelper.instance.jsonDecode(response.bodyBytes);
      Film film = Film.fromJson(res);
      return film;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/features/comment/comment_service.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:http/http.dart' as http;

import 'article_model.dart';

class ArticleService {
  ArticleService._instantiate();

  static final ArticleService instance = ArticleService._instantiate();

  Future<SearchResult<Article>> search(String? textInput) async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    int limit = 24;
    var bodyMap = {
      'author': userId,
      'limit': limit,
    };
    //TODO: should search desc || title
    if (textInput != null) {
      bodyMap['description'] = textInput;
    }

    final headers = await HttpHelper.instance.buildHeader();
    late String baseUrl = HttpHelper.instance.getUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/articles/search'),
      headers: headers,
      body: jsonEncode(bodyMap),
    );

    if (response.statusCode == 200) {
      dynamic res = json.decode(utf8.decode(response.bodyBytes));
      SearchResult<Article> searchResult = SearchResult.fromJson(res);
      return searchResult;
    }

    throw json.decode(response.body)['error']['message'];
  }

  Future<Article> getByID(String id) async {
    late String baseUrl = HttpHelper.instance.getUrl();
    final response = await http.get(Uri.parse('$baseUrl/articles/$id'));

    if (response.statusCode == 200) {
      var res = jsonDecode(utf8.decode(response.bodyBytes));
      Article article = Article.fromJson(res);
      return article;
    }

    throw json.decode(response.body)['error']['message'];
  }
}

class ArticleCommentThread extends FilmCommentThreadClient {
  ArticleCommentThread() : super();

  ArticleCommentThread._instantiate();

  static final ArticleCommentThread instance =
      ArticleCommentThread._instantiate();

  // String name = "articles";
  @override
  String url = HttpHelper.instance.getUrl() + "/articles";
}

class ArticleCommentThreadReply extends FilmCommentThreadReplyClient {
  ArticleCommentThreadReply() : super();

  ArticleCommentThreadReply._instantiate();

  static final ArticleCommentThreadReply instance =
      ArticleCommentThreadReply._instantiate();
  @override
  String url = HttpHelper.instance.getUrl() + "/articles";
}

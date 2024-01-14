import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:http/http.dart' as http;

abstract class SearchCommentThreadService<CommentThread> {
  Future<SearchResult<CommentThread>> search(String serviceName, String id);
}

class SearchCommentThreadClient
    implements SearchCommentThreadService<CommentThread> {
  SearchCommentThreadClient._instantiate();
  static final SearchCommentThreadClient instance =
      SearchCommentThreadClient._instantiate();
  late String baseUrl = HttpHelper.instance.getUrl();

  SearchCommentThreadClient(this.baseUrl);

  @override
  Future<SearchResult<CommentThread>> search(
      String serviceName, String id) async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse('$baseUrl/$serviceName/commentthread/search'),
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
      SearchResult<CommentThread> searchResult = SearchResult.fromJson(res);
      return searchResult;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

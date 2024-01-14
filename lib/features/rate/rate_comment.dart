import 'package:flutter_user/common/models/search.dart';

abstract class CommentService<T> {
  Future<SearchResult<T>> getComments(String id, String author, String userId);

  Future<T> getComment(String id, String author, String userId);

  Future<int> update(String id, String author, String userId, dynamic comment);

  Future<int> delete(String id, String author, String userId);
}

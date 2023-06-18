import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:http/http.dart' as http;

abstract class CommentService<T> {
  Future<SearchResult<T>> getComments(String id, String author, String userId);

  Future<T> getComment(String id, String author, String userId);

  Future<int> update(String id, String author, String userId, dynamic comment);

  Future<int> delete(String id, String author, String userId);
}

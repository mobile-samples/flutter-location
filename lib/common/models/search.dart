import 'package:flutter_user/features/account/user_model.dart';
import 'package:flutter_user/features/company/company_model.dart';
import 'package:flutter_user/features/film/film_model.dart';
import 'package:flutter_user/features/rate/rate_model.dart';
import 'package:flutter_user/features/comment/comment_model.dart';

import '../../features/location/location_model.dart';

class Filter {
  int? page;
  int? limit;
  int? firstLimit;
  List<String>? fields; //string[];
  String? sort;

  String? q;
  String? keyword;

  int? pageIndex;
  int? pageSize;

  Filter(this.limit, this.page);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['firstLimit'] = firstLimit;
    data['fields'] = fields;
    data['q'] = q;
    data['keyword'] = keyword;
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;

    return data;
  }
}

class SearchResult<T> {
  List<T> list;
  int total;
  bool? last;
  String? nextPageToken;

  SearchResult(
    this.list,
    this.total,
  );

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    build() {
      switch (T) {
        case Location:
          return List<T>.from(json['list'].map((x) => Location.fromJson(x)));
        case RateComment:
          return List<T>.from(json['list'].map((x) => RateComment.fromJson(x)));
        case RateReply:
          return List<T>.from(json['list'].map((x) => RateReply.fromJson(x)));
        case Company:
          return List<T>.from(json['list'].map((x) => Company.fromJson(x)));
        case UserInfo:
          return List<T>.from(json['list'].map((x) => UserInfo.fromJson(x)));
        case Film:
          return List<T>.from(json['list'].map((x) => Film.fromJson(x)));
        case CommentThread:
          return List<T>.from(
              json['list'].map((x) => CommentThread.fromJson(x)));
        case CommentReply:
          return List<T>.from(
              json['list'].map((x) => CommentReply.fromJson(x)));
        default:
          return null;
      }
    }
    return SearchResult(
      json['list'] != null ? build() ?? [] : [],
      json['total'],
    );
  }
}

class SaveResult<T> {
  int status;
  T value;
  SaveResult(this.status, this.value);
  factory SaveResult.fromJson(Map<String, dynamic> json) {
    build() {
      switch (T) {
        case UserInfo:
          return UserInfo.fromJson(json);

        default:
          return null;
      }
    }
    return SaveResult(
      json['status'],
      (json['value'] != null ? build() ?? [] : []) as T,
    );
  }
}

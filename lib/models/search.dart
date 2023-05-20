
import 'package:flutter_user/models/film.dart';
import 'package:flutter_user/models/location.dart';
import 'package:flutter_user/models/rate.dart';
import 'company.dart';
import 'package:flutter_user/models/user.dart';
import 'package:flutter_user/models/comment.dart';

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['firstLimit'] = this.firstLimit;
    data['fields'] = this.fields;
    data['q'] = this.q;
    data['keyword'] = this.keyword;
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;

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
    final _build = () {
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
          return List<T>.from(json['list'].map((x) => CommentThread.fromJson(x)));
        case CommentReply:
          return List<T>.from(json['list'].map((x) => CommentReply.fromJson(x)));
        default:
          return null;
      }
    };
    return SearchResult(
      json['list'] != null ? _build() ?? [] : [],
      json['total'],
    );
  }
}

class SaveResult<T> {
  int status;
  T value;
  SaveResult(this.status, this.value);
  factory SaveResult.fromJson(Map<String, dynamic> json) {
    final _build = () {
      switch (T) {
        case UserInfo:
          return UserInfo.fromJson(json);

        default:
          return null;
      }
    };
    return SaveResult(
      json['status'],
      (json['value'] != null ? _build() ?? [] : []) as T,
    );
  }
}

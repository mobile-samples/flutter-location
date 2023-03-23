import 'package:flutter_user/models/location.dart';
import 'package:flutter_user/models/rate.dart';

abstract class Filter {
  int? page;
  int? limit;
  int? firstLimit;
  List<String>? fields; //string[];
  String? sort;
  String? currentUserId;

  String? q;
  String? keyword;
  List<String>? excluding; //string[]|number[];
  String? refId; //string|number;

  int? pageIndex;
  int? pageSize;

  Filter(this.limit, this.page);
}

class SearchResult<T> {
  List<T> list;
  String total;
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

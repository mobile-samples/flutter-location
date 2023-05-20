import 'package:flutter_user/models/history.dart';

class RateComment {
  RateComment(
      this.author,
      this.authorName,
      this.id,
      this.ratetime,
      this.review,
      this.disable,
      this.rate,
      this.rates,
      this.replyCount,
      this.usefulCount,
      this.anonymous);

  String? author;
  String? authorName;
  String? id;
  String? ratetime;
  String? review;
  bool disable;
  double? rate;
  List<int>? rates;
  int? replyCount;
  int? usefulCount;
  bool anonymous;

  factory RateComment.fromJson(Map<String, dynamic> json) => RateComment(
      json['author'],
      json['authorName'] != null ? json['authorName'] : '',
      json['id'],
      json['time'],
      json['review'],
      json['disable'] != null ? json['disable'] : false,
      json['rate'] != null ? double.parse(json['rate'].toString()) : 0.0,
      json['rates'] != null  ? json['rates'].cast<int>() : null,
      json['replyCount'],
      json['usefulCount'],
      json['anonymous'] != null ? json['anonymous'] : false);
}

class RateReply {
  RateReply(this.author, this.authorName, this.id, this.commentId, this.time,
      this.comment, this.authorURL, this.anonymous);

  String? author;
  String? authorName;
  String? id;
  String? commentId;
  String? time;
  String? comment;
  String? authorURL;
  bool? anonymous;
  List<Histories>? histories;

  RateReply.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    id = json['id'];
    author = json['author'];
    comment = json['comment'];
    time = json['time'];
    authorName = json['authorName'] != null ? json['authorName'] : '';
    authorURL = json['authorURL'] != null ? json['authorURL'] : '';
    anonymous = json['anonymous'] == null ? false : json['anonymous'];
    if (json['histories'] != null) {
      histories = <Histories>[];
      json['histories'].forEach((v) {
        histories!.add(new Histories.fromJson(v));
      });
    }
  }

  factory RateReply.fromJson(Map<String, dynamic> json) => RateReply(
      json['author'],
      json['authorName'] != null ? json['authorName'] : '',
      json['id'],
      json['commentId'],
      json['time'],
      json['comment'],
      json['authorURL'] != null ? json['authorURL'] : '',
      json['anonymous'] != null ? json['anonymous'] : false);
}

import 'package:flutter_user/common/models/history_model.dart';

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
      json['authorName'] ?? '',
      json['id'],
      json['time'],
      json['review'],
      json['disable'] ?? false,
      json['rate'] != null ? double.parse(json['rate'].toString()) : 0.0,
      json['rates']?.cast<int>(),
      json['replyCount'],
      json['usefulCount'],
      json['anonymous'] ?? false);
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
    authorName = json['authorName'] ?? '';
    authorURL = json['authorURL'] ?? '';
    anonymous = json['anonymous'] ?? false;
    if (json['histories'] != null) {
      histories = <Histories>[];
      json['histories'].forEach((v) {
        histories!.add(Histories.fromJson(v));
      });
    }
  }
}

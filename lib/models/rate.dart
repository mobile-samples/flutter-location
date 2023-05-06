class RateComment {
  RateComment(
      this.author,
      this.authorName,
      this.id,
      this.ratetime,
      this.review,
      this.disable,
      this.rate,
      this.replyCount,
      this.usefulCount,
      this.anonymous);
  String? author;
  String? authorName;
  String? id;
  String? ratetime;
  String? review;
  bool disable;
  int? rate;
  int? replyCount;
  int? usefulCount;
  bool anonymous;

  factory RateComment.fromJson(Map<String, dynamic> json) => RateComment(
      json['author'],
      json['authorName'] != null ? json['authorName'] : '',
      json['id'],
      json['ratetime'],
      json['review'],
      json['disable'],
      json['rate'],
      json['replyCount'],
      json['usefulCount'],
      json['anonymous'] != null ? json['anonymous'] : false);
}

class RateReply {
  RateReply(this.author, this.authorName, this.id, this.commentId, this.time,
      this.comment, this.userURL, this.anonymous);
  String? author;
  String? authorName;
  String? id;
  String? commentId;
  String? time;
  String? comment;
  String? userURL;
  bool anonymous;

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

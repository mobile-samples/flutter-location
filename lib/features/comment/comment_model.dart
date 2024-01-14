import 'package:flutter_user/common/models/history_model.dart';

class CommentThread {
  String? commentId;
  String? id;
  String? author;
  String? comment;
  String? time;
  String? updatedAt;
  List<Histories>? histories;
  int? replyCount;
  int? usefulCount;
  String? authorName;
  String? authorURL;
  bool? disable;
  bool? anonymous;

  CommentThread(
      {this.commentId,
      this.id,
      this.author,
      this.comment,
      this.time,
      this.updatedAt,
      this.histories,
      this.replyCount,
      this.usefulCount,
      this.authorName,
      this.authorURL,
      this.disable,
      this.anonymous});

  CommentThread.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    id = json['id'];
    author = json['author'];
    comment = json['comment'];
    time = json['time'];
    updatedAt = json['updatedAt'];
    if (json['histories'] != null) {
      histories = <Histories>[];
      json['histories'].forEach((v) {
        histories!.add(Histories.fromJson(v));
      });
    }
    replyCount = json['replyCount'];
    usefulCount = json['usefulCount'];
    authorName = json['authorName'];
    authorURL = json['authorURL'];
    disable = json['disable'];
    anonymous = json['anonymous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentId'] = commentId;
    data['id'] = id;
    data['author'] = author;
    data['comment'] = comment;
    data['time'] = time;
    data['updatedAt'] = updatedAt;
    if (histories != null) {
      data['histories'] = histories!.map((v) => v.toJson()).toList();
    }
    data['replyCount'] = replyCount;
    data['usefulCount'] = usefulCount;
    data['authorName'] = authorName;
    data['authorURL'] = authorURL;
    data['disable'] = disable;
    data['anonymous'] = anonymous;
    return data;
  }
}

class CommentReply {
  CommentReply(this.author, this.authorName, this.id, this.commentId, this.time,
      this.comment, this.authorURL, this.histories);
  String? author;
  String? authorName;
  String? id;
  String? commentId;
  String? time;
  String? comment;
  String? authorURL;
  List<Histories>? histories;

  CommentReply.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    id = json['id'];
    author = json['author'];
    comment = json['comment'];
    time = json['time'];
    if (json['histories'] != null) {
      histories = <Histories>[];
      json['histories'].forEach((v) {
        histories!.add(Histories.fromJson(v));
      });
    }
    authorName = json['authorName'];
    authorURL = json['authorURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentId'] = commentId;
    data['id'] = id;
    data['author'] = author;
    data['comment'] = comment;
    data['time'] = time;
    if (histories != null) {
      data['histories'] = histories!.map((v) => v.toJson()).toList();
    }
    data['authorName'] = authorName;
    data['authorURL'] = authorURL;
    return data;
  }
}

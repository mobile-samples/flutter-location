
class Histories {
  String? time;
  int? rate;
  String? comment;

  Histories({this.time, this.rate, this.comment});

  Histories.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    rate = json['rate'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['rate'] = rate;
    data['comment'] = comment;
    return data;
  }
}

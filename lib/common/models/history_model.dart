
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['rate'] = this.rate;
    data['comment'] = this.comment;
    return data;
  }
}

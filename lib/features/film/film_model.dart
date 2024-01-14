class Film {
  Film(
      this.createdat,
      this.createdby,
      this.description,
      this.id,
      this.imageURL,
      this.trailerURL,
      this.categories,
      this.directors,
      this.casts,
      this.productions,
      this.countries,
      this.writer,
      this.gallery,
      this.coverurl,
      this.info,
      this.title,
      this.status,
      this.type,
      this.updatedby,
      this.version);
  String? createdat;
  String? createdby;
  String? description;
  String? id;
  String? imageURL;
  String? trailerURL;
  List<String>? categories;
  List<String>? directors;
  List<String>? casts;
  List<String>? productions;
  List<String>? countries;
  String? writer;
  List<String> gallery;
  String? coverurl;
  Info? info;
  String? title;
  String? status;
  String? type;
  String? updatedby;
  String? version;


  factory Film.fromJson(Map<String, dynamic> json) => Film(
      json['createdat'] ?? '',
      json['createdby'] ?? '',
      json['description'] ?? '',
      json['id'] ?? '',
      json['imageURL'] ?? '',
      json['trailerURL'] ?? '',
      json['categories'] == null ? [] : json['categories'].cast<String>(),
      json['directors'] == null ? [] : json['directors'].cast<String>(),
      json['casts'] == null ? [] : json['casts'].cast<String>(),
      json['productions'] == null ? [] : json['productions'].cast<String>(),
      json['countries'] == null ? [] : json['countries'].cast<String>(),
      json['writer'] ?? '',
      json['gallery'] == null ? [] : json['gallery'].cast<String>(),
      json['coverurl'] ?? '',
      json['info'] != null ? Info.fromJson(json['info']) : null,
      json['title'] ?? '',
      json['status'] ?? '',
      json['type'] ?? '',
      json['updatedby'] ?? '',
      json['version'] ?? '');
}

class Info {
  Info(
    this.count,
    this.rate,
    this.rate1,
    this.rate2,
    this.rate3,
    this.rate4,
    this.rate5,
    this.rate6,
    this.rate7,
    this.rate8,
    this.rate9,
    this.rate10,
    this.score,
  );
  int? count;
  double? rate;
  int? rate1;
  int? rate2;
  int? rate3;
  int? rate4;
  int? rate5;
  int? rate6;
  int? rate7;
  int? rate8;
  int? rate9;
  int? rate10;
  int? score;

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'rate': rate,
      'rate1': rate1,
      'rate2': rate2,
      'rate3': rate3,
      'rate4': rate4,
      'rate5': rate5,
      'rate6': rate6,
      'rate7': rate7,
      'rate8': rate8,
      'rate9': rate9,
      'rate10': rate10,
      'score': score,
    };
  }

  factory Info.fromJson(Map<String, dynamic> json) => Info(
      json['count'] ?? 0,
      json['rate'] == null
          ? 0
          : (json['rate'] is int
              ? double.parse(json['rate'].toString())
              : json['rate']),
      json['rate1'],
      json['rate2'],
      json['rate3'],
      json['rate4'],
      json['rate5'],
      json['rate6'],
      json['rate7'],
      json['rate8'],
      json['rate9'],
      json['rate10'],
      json['score']);
}

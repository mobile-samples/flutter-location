class Company {
  Company(
    this.id,
    this.name,
    this.description,
    this.size,
    this.address,
    this.imageURL,
    this.status,
    this.establishedAt,
    this.categories,
    this.galleries,
    this.info,
  );

  String? id;
  String? name;
  String? description;
  int? size;
  String? address;
  String? imageURL;
  String? status;
  String? establishedAt;
  List<String>? categories;
  List<String>? galleries;
  CompanyInfo? info;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        json['id'] == null ? '' : json['id'],
        json['name'] == null ? '' : json['name'],
        json['description'] == null ? '' : json['description'],
        json['size'] == null ? 0 : json['size'],
        json['address'] == null ? '' : json['address'],
        json['imageURL'] == null ? '' : json['imageURL'],
        json['status'] == null ? '' : json['status'],
        json['establishedAt'] == null ? '' : json['establishedAt'],
        json['categories'] == null ? null : json['categories'].cast<String>(),
        json['gallery'] == null ? null : json['gallery'],
        json['info'] == null ? null : CompanyInfo.fromJson(json['info']),
      );
}

class CompanyInfo {
  CompanyInfo(
    this.rate,
    this.rate1,
    this.rate2,
    this.rate3,
    this.rate4,
    this.rate5,
    this.count,
    this.score,
  );

  double? rate;
  int? rate1;
  int? rate2;
  int? rate3;
  int? rate4;
  int? rate5;
  int? count;
  double? score;

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      json['rate'] == null ? 0.0 : double.parse(json['rate'].toString()),
      json['rate1'],
      json['rate2'],
      json['rate3'],
      json['rate4'],
      json['rate5'],
      json['count'] == null ? 0 : json['count'],
      json['score'] == null ? 0.0 : double.parse(json['score'].toString()),
    );
  }
}

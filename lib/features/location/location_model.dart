class Location {
  Location(
      this.createdat,
      this.createdby,
      this.customurl,
      this.description,
      this.geo,
      this.id,
      this.imageURL,
      this.info,
      this.latitude,
      this.longitude,
      this.name,
      this.status,
      this.type,
      this.updatedby,
      this.version);
  String? createdat;
  String? createdby;
  String? customurl;
  String? description;
  String? geo;
  String? id;
  String? imageURL;
  LocationInfo? info;
  double? latitude;
  double? longitude;
  String? name;
  String? status;
  String? type;
  String? updatedby;
  String? version;
  factory Location.fromJson(Map<String, dynamic> json) => Location(
      json['createdat'] ?? '',
      json['createdby'] ?? '',
      json['customurl'] ?? '',
      json['description'] ?? '',
      json['geo'] ?? '',
      json['id'] ?? '',
      json['imageURL'] ?? '',
      json['info'] != null ? LocationInfo.fromJson(json['info']) : null,
      json['latitude'] ?? '',
      json['longitude'] ?? '',
      json['name'] ?? '',
      json['status'] ?? '',
      json['type'] ?? '',
      json['updatedby'] ?? '',
      json['version'] ?? '');
}

class LocationInfo {
  LocationInfo(
    this.count,
    this.rate,
    this.rate1,
    this.rate2,
    this.rate3,
    this.rate4,
    this.rate5,
    this.score,
  );
  int? count;
  double? rate;
  int? rate1;
  int? rate2;
  int? rate3;
  int? rate4;
  int? rate5;
  String? score;

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'rate': rate,
      'rate1': rate1,
      'rate2': rate2,
      'rate3': rate3,
      'rate4': rate4,
      'rate5': rate5,
      'score': score,
    };
  }

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
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
      json['score']);
}

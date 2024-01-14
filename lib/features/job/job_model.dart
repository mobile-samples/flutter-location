import 'package:flutter_user/common/client/model.dart';

class Job {
  Job(
    this.id,
    this.title,
    this.description,
    this.skill,
    this.quantity,
    this.applicantCount,
    this.requirements,
    this.benefit,
    this.companyId,
    this.publishedAt,
    this.expiredAt,
  );

  String id;
  String title;
  String description;
  List<String> skill;
  num quantity;
  num applicantCount;
  String requirements;
  String benefit;
  String companyId;
  DateTime? publishedAt;
  DateTime? expiredAt;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        json['id'] as String,
        json['title'] as String,
        json['description'] as String,
        (json['skill'] as List<dynamic>).map((e) => e as String).toList(),
        json['quantity'] as num,
        json['applicantCount'] as num,
        json['requirements'] as String,
        json['benefit'] as String,
        json['companyId'] as String,
        json['publishedAt'] == null
            ? null
            : DateTime.parse(json['publishedAt'] as String),
        json['expiredAt'] == null
            ? null
            : DateTime.parse(json['expiredAt'] as String),
      );

  Map<String, dynamic> toJson(Job instance) => {
        'id': instance.id,
        'title': instance.title,
        'description': instance.description,
        'skill': instance.skill,
        'quantity': instance.quantity,
        'applicantCount': instance.applicantCount,
        'requirements': instance.requirements,
        'benefit': instance.benefit,
        'companyId': instance.companyId,
        'publishedAt': instance.publishedAt?.toIso8601String(),
        'expiredAt': instance.expiredAt?.toIso8601String(),
      };
  static String getId(Job job) => job.id;
}

class JobFilter extends Filter {
  JobFilter(
    // this.id,
    // this.title,
    // this.description,
    // this.skill,
    // this.quantity,
    // this.applicantCount,
    // this.requirements,
    // this.benifit,
    // this.companyId,
    // this.publishedAt,
    // this.expiredAt,
    super.limit,
    super.page,
  );

  String? id;
  String? title;
  String? description;
  List<String>? skill;
  num? quantity;
  num? applicantCount;
  String? requirements;
  String? benifit;
  String? companyId;
  DateTime? publishedAt;
  DateTime? expiredAt;

  @override
  Map<String, dynamic> toJson() => {
        'limit': limit ?? 0,
        'page': page ?? 0,
      };
}

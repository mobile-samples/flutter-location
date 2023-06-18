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
    this.benifit,
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
  String benifit;
  String companyId;
  DateTime? publishedAt;
  DateTime? expiredAt;

  Map<String, dynamic> toJson() => {};

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        json['JobId'] ?? json['Jobid'],
        json['Jobname'] ?? '',
        json['email'],
        json['displayName'] ?? json['displayname'],
        json['imageURL'] ?? json['imageurl'],
        json['status'],
        json['gender'] ?? '',
        json['phone'] ?? '',
        json['title'] ?? '',
        json['position'] ?? '',
        json['roles']?.cast<String>(),
      );

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
    int? limit,
    int? page,
  ) : super(limit, page);

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

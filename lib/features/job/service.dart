import 'dart:io';

import 'package:flutter_user/common/client/client.dart';
import 'package:flutter_user/common/client/model.dart';

import 'model.dart';

class JobService extends Client<Job, String, ResultInfo<Job>, JobFilter> {
  static final JobService instance = JobService._instantiate();

  JobService._instantiate()
      : super(
          serviceUrl: Platform.isIOS
              ? 'http://localhost:8083/users'
              : 'http://10.0.2.2:8083/users',
          createObjectFromJson: Job.fromJson,
          getId: Job.getId,
        );
}

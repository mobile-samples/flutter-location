import 'package:flutter_user/common/client/client.dart';
import 'package:flutter_user/utils/http_helper.dart';

import 'job_model.dart';

class JobService extends Client<Job, String, JobFilter> {
  static final JobService instance = JobService._instantiate();

  JobService._instantiate()
      : super(
          serviceUrl: HttpHelper.instance.getUrl() + '/jobs',
          fromJson: Job.fromJson,
          getId: Job.getId,
        );
}

import 'package:flutter/material.dart';
import 'package:flutter_user/common/client/client.dart';
import 'package:flutter_user/common/client/model.dart';
import 'package:flutter_user/common/client/search_state.dart';
import 'package:flutter_user/common/widgets/custom_appbar.dart';
import 'package:flutter_user/features/job/job_model.dart';
import 'package:flutter_user/features/job/job_service.dart';
import 'package:flutter_user/utils/screen_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'job_card.dart';
import 'job_detail.dart';

class JobListWidget extends StatefulWidget {
  const JobListWidget({super.key});

  @override
  State<JobListWidget> createState() => _JobListWidgetState();
}

class _JobListWidgetState extends SearchState<JobListWidget, Job, JobFilter> {
  final ScrollController _scrollController = ScrollController();
  late JobFilter filter;

  @override
  JobFilter getFilter() {
    return filter;
  }

  @override
  Client<Job, String, JobFilter> getService() {
    return JobService.instance;
  }

  @override
  void setFilter() {
    setState(() {
      filter = JobFilter(20, 1);
    });
  }

  gotoDetail(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetail(id: id)));
  }

  @override
  PreferredSizeWidget buildAppbar(BuildContext context) {
    return getAppBarWithoutArrowBack(
        context, AppLocalizations.of(context)!.job_list_title);
  }

  @override
  Widget buildChild(BuildContext context, SearchResult<Job> searchResult) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (searchResult.list.isNotEmpty) {
                return GestureDetector(
                    onTap: () async {
                      final reLoadPage =
                          await gotoDetail(searchResult.list[index].id);
                      if (reLoadPage == null || reLoadPage == true) {
                        search();
                        autoScrollOnTop(_scrollController);
                      }
                    },
                    child: JobCard(
                      data: searchResult.list[index],
                    ));
              } else {
                return Container();
              }
            },
            childCount: searchResult.list.length,
          ),
        ),
      ],
    );
  }
}

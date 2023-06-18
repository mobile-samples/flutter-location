import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/common/client/client.dart';
import 'package:flutter_user/common/client/model.dart';
import 'package:flutter_user/common/client/search_state.dart';
import 'package:flutter_user/common/widgets/custom_appbar.dart';
import 'package:flutter_user/features/job/model.dart';
import 'package:flutter_user/features/job/service.dart';
import 'package:flutter_user/utils/screen_utils.dart';

import 'card.dart';
import 'detail.dart';

class ArticleListWidget extends StatefulWidget {
  const ArticleListWidget({Key? key}) : super(key: key);

  @override
  State<ArticleListWidget> createState() => _ArticleListWidgetState();
}

class _ArticleListWidgetState
    extends SearchState<ArticleListWidget, Job, JobFilter> {
  final ScrollController _scrollController = ScrollController();
  late JobFilter filter;

  @override
  JobFilter getFilter() {
    return filter;
  }

  @override
  Client<Job, String, ResultInfo<Job>, JobFilter> getService() {
    return JobService.instance;
  }

  @override
  void setFilter() {
    setState(() {
      filter = JobFilter(20, 1);
    });
  }

  gotoDetail(String id) {
    Navigator.pushNamed(context, JobDetail.routeName, arguments: id);
  }

  @override
  PreferredSizeWidget buildAppbar(BuildContext context) {
    return getAppBarWithArrowBack(context, "Jobs");
  }

  @override
  Widget buildChild(BuildContext context, SearchResult<Job> searchResult) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Implement search form
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

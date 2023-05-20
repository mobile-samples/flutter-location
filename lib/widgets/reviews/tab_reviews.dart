import 'package:flutter/material.dart';
import 'package:flutter_user/models/film.dart';
import 'package:flutter_user/models/comment.dart';
import 'package:flutter_user/models/rate.dart';
import 'package:flutter_user/services/reaction/reaction_comment.dart';
import 'package:flutter_user/services/reaction/reaction.dart';
import 'package:flutter_user/services/rate/rate_comment.dart';
import 'package:flutter_user/services/search/search_rate.dart';
import 'package:flutter_user/services/search/search_comment.dart';
import 'package:flutter_user/services/comment.dart';
import 'package:flutter_user/widgets/reviews/comment/comment_tab.dart';
import 'package:flutter_user/widgets/reviews/rate/review_tab.dart';

class TabReviews extends StatefulWidget {
  const TabReviews({
    Key? key,
    required this.id,
    this.info,
    required this.rateRange,
    required this.load, required this.reactionRateService, required this.reactionCommentService, required this.rateService, required this.searchRateService, required this.rateCommentService, required this.searchCommentThreadService, required this.commentThreadService, required this.commentThreadReplyService,
  }) : super(key: key);
  final String id;
  final Info? info;
  final int rateRange;
  final Function load;

  final ReactionService reactionRateService;
  final ReactionService reactionCommentService;
  final RateService rateService ;
  final SearchRateService<RateComment> searchRateService ;
  final RateCommentService rateCommentService ;
  final SearchCommentThreadService<CommentThread> searchCommentThreadService ;
  final CommentThreadService commentThreadService ;
  final CommentThreadReplyService commentThreadReplyService;

  @override
  State<TabReviews> createState() => _TabReviewsState();
}

class _TabReviewsState extends State<TabReviews> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25.0)),
                child: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(25.0)),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Review',
                    ),
                    Tab(
                      text: 'Comment',
                    )
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                          child: ReviewsTab(
                        id: widget.id ?? '',
                        rateRange: widget.rateRange,
                        info: widget.info,
                        load: widget.load,
                        reactionRateService: widget.reactionRateService,
                        rateService: widget.rateService,
                        searchRateService: widget.searchRateService,
                        rateCommentService: widget.rateCommentService,
                      )),
                      CommentTab(
                        id: widget.id ?? "",
                        load: widget.load,
                        searchCommentThreadService: widget.searchCommentThreadService,
                        reactionService: widget.reactionCommentService,
                        commentThreadService: widget.commentThreadService,
                        commentThreadReplyService: widget.commentThreadReplyService,
                      ),
                    ],
                  )),
            ],
          ),
        )));
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_user/models/film.dart';
import 'package:flutter_user/services/reaction/reaction.dart';
import 'package:flutter_user/services/search/search_rate.dart';
import 'package:flutter_user/services/rate/rate_comment.dart';
import 'package:flutter_user/models/rate.dart';
import 'package:flutter_user/widgets/reviews/rate/rate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsTab extends StatefulWidget {
  const ReviewsTab({
    Key? key,
    required this.id,
    required this.rateRange,
    this.info,
    required this.load,
    required this.reactionRateService,
    required this.rateService,
    required this.searchRateService,
    required this.rateCommentService,
  }) : super(key: key);
  final String id;
  final int rateRange;
  final Info? info;
  final Function load;
  final ReactionService reactionRateService;
  final RateService rateService;
  final SearchRateService<RateComment> searchRateService;
  final RateCommentService rateCommentService;

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  @override
  void initState() {
    super.initState();
    // widget.search(widget.id);
  }

  Widget ListStars(Info? info, int rateRange, BuildContext context) {
    List<Widget> list = [];
    final infoMap = info?.toMap();
    if ((info?.rate ?? 0) == 0) {
      return new Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'No data for statistics yet.',
              style: Theme.of(context).textTheme.labelSmall,
            ))
      ]);
    }
    for (var i = rateRange; i > 0; i--) {
      final per = infoMap?['rate' + i.toString()] ?? 0;
      list.add(Row(
        children: [
          RatingBar.builder(
            ignoreGestures: true,
            initialRating: double.parse(i.toString()),
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: i,
            itemSize: 12,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onRatingUpdate: (rating) {},
          ),
          Container(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.tertiary,
                ),
                value: ((per * 100) / 10) ?? 0,
              )),
        ],
      ));
    }
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.end, children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.0), // set the top padding value here
          child: Text(
            'Rating & Reviews',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if ((widget.info?.rate ?? 0) > 0)
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.info?.rate.toString() ?? '0',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'out of 10',
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                ),
              )),
        Row(
          children: [
            ListStars(widget.info, widget.rateRange, context),
          ],
        ),
        Rates(
          id: widget.id,
          load: widget.load,
          reactionRateService: widget.reactionRateService,
          rateService: widget.rateService,
          searchRateService: widget.searchRateService,
          rateCommentService: widget.rateCommentService,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_user/models/rate.dart';
import 'package:flutter_user/models/search.dart';
import 'package:flutter_user/services/rate/rate_comment.dart';
import 'package:flutter_user/services/reaction/reaction.dart';
import 'package:flutter_user/services/search/search_rate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_user/widgets/reviews/rate/rate_form.dart';
import 'package:flutter_user/widgets/reviews/rate/reply_list.dart';
import 'package:avatars/avatars.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Rates extends StatefulWidget {
  const Rates(
      {Key? key,
      required this.id,
      required this.load,
      required this.reactionRateService,
      required this.rateService,
      required this.searchRateService,
      required this.rateCommentService})
      : super(key: key);
  final String id;
  final Function load;
  final ReactionService reactionRateService;
  final RateService rateService;
  final SearchRateService<RateComment> searchRateService;
  final RateCommentService rateCommentService;

  @override
  State<Rates> createState() => _RatesState();
}

class _RatesState extends State<Rates> {
  late SearchResult<RateComment> listRate;
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    getRateComment();
  }

  getRateComment() async {
    final res = await widget.searchRateService.search(widget.id);
    setState(() {
      listRate = res;
      _loading = false;
    });
  }

  int calcrRanks(ranks) {
    double multiplier = 1;
    return (multiplier * ranks).round();
  }

  postRate<double>(double rate, String review, bool anonymous) async {
    final date = DateTime.now().toIso8601String();
    final rateInt = calcrRanks(rate);
    final res = await widget.rateService.postRate(widget.id, rateInt, review, date, anonymous);
    if (res > 0) {
      await getRateComment();
      await widget.load();
      return 1;
    }
    return 0;
  }

  useFul(String authorOfRate) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res = await widget.reactionRateService
        .setUseful(widget.id, authorOfRate, userId);
    if (res > 0) {
      await getRateComment();
    }
  }

  deleteUseFul(String authorOfRate) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res = await widget.reactionRateService
        .removeUseful(widget.id, authorOfRate, userId);
    if (res > 0) {
      await getRateComment();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: new AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          style: Theme.of(context).textButtonTheme.style,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0))),
                builder: (BuildContext buildContext) {
                  return RateForm(postRate: postRate);
                });
          },
          child: Text('Post a Review'),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: listRate.list.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color.fromARGB(240, 240, 240, 240),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Review by ' +
                                (!listRate.list[index].anonymous
                                    ? listRate.list[index].authorName ??
                                        'Anonymous'
                                    : 'Anonymous'),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          Spacer(),
                        ],
                      ),
                      Divider(),
                      Container(
                        width: double.maxFinite,
                        height: 120,
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Avatar(
                                      name:
                                          listRate.list[index].authorName ?? "",
                                      shape: AvatarShape.circle(22.0)),
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: double.parse(
                                        listRate.list[index].rate.toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 10,
                                    itemSize: 14,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ]),
                            Spacer(),
                            Text(
                              listRate.list[index].review ?? '',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (!listRate.list[index].disable) {
                                            useFul(
                                                listRate.list[index].author ??
                                                    '');
                                          } else {
                                            deleteUseFul(
                                                listRate.list[index].author ??
                                                    '');
                                          }
                                        },
                                        icon: Icon(listRate.list[index].disable
                                            ? Icons.favorite
                                            : Icons.favorite_outline)),
                                    Text(listRate.list[index].usefulCount
                                        .toString())
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20.0))),
                                              builder:
                                                  (BuildContext buildContext) {
                                                return RateReplies(
                                                    load: getRateComment,
                                                    id: widget.id,
                                                    authorOfRate: listRate
                                                        .list[index].author,
                                                    rateCommentClient: widget
                                                        .rateCommentService);
                                              });
                                        },
                                        icon: Icon(Icons.comment_outlined)),
                                    Text(listRate.list[index].replyCount
                                        .toString())
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}

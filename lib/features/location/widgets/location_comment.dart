import 'package:flutter/material.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/features/rate/rate_model.dart';
import 'package:flutter_user/features/rate/rate_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'location_form_rate.dart';
import 'location_form_reply.dart';

class LocationComment extends StatefulWidget {
  const LocationComment(
      {super.key, required this.locationId, required this.getLocationDetail});
  final String locationId;
  final Function getLocationDetail;

  @override
  State<LocationComment> createState() => _LocationCommentState();
}

class _LocationCommentState extends State<LocationComment> {
  late SearchResult<RateComment> listRate;
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    getRateComment();
  }

  getRateComment() async {
    final res = await RateService.instance
        .search('/locations/rates/search', widget.locationId, 'time desc');
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
    final res = await RateService.instance
        .postRate(widget.locationId, rateInt, review, date, anonymous);
    if (res > 0) {
      await getRateComment();
      await widget.getLocationDetail();
      return 1;
    }
    return 0;
  }

  useFul(String authorOfRate, bool useful) async {
    final res = await RateService.instance
        .postUseful(widget.locationId, 'locations', authorOfRate, useful);
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
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return Column(
      children: [
        TextButton(
          style: Theme.of(context).textButtonTheme.style,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0))),
                builder: (BuildContext buildContext) {
                  return RateForm(postRate: postRate);
                });
          },
          child: const Text('Post a Review'),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: listRate.total,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review by ${!listRate.list[index].anonymous
                                ? listRate.list[index].authorName ?? 'Anonymous'
                                : 'Anonymous'}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.maxFinite,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(
                                  listRate.list[index].rate.toString()),
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 14,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Text(
                              listRate.list[index].review ?? '',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      useFul(listRate.list[index].author ?? '',
                                          !listRate.list[index].disable);
                                    },
                                    icon: Icon(listRate.list[index].disable
                                        ? Icons.favorite
                                        : Icons.favorite_outline)),
                                Text(listRate.list[index].usefulCount
                                    .toString()),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0))),
                                          builder: (BuildContext buildContext) {
                                            return ReplyForm(
                                                serviceName: "locations",
                                                locationId: widget.locationId,
                                                authorOfRate: listRate
                                                    .list[index].author ?? '');
                                          });
                                    },
                                    icon: const Icon(Icons.comment_outlined)),
                                Text(listRate.list[index].replyCount.toString())
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

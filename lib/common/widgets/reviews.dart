import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/features/location/widgets/location_form_reply.dart';
import 'package:flutter_user/features/rate/rate_model.dart';
import 'package:flutter_user/features/rate/rate_service.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key, 
    required this.id,
    required this.serviceName,
    required this.rateRes,
    required this.getRates,
  });

  final String id;
  final String serviceName;
  final SearchResult<RateComment> rateRes;
  final Function getRates;

  @override
  State<StatefulWidget> createState() {
    return _ReviewsState();
  }
}

class _ReviewsState extends State<Reviews> {
  useFul(String authorOfRate, bool useful) async {
    final res = await RateService.instance
        .postUseful(widget.serviceName, widget.id, authorOfRate, useful);
    if (res > 0) {
      await widget.getRates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.rateRes.total,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review by ${!widget.rateRes.list[index].anonymous
                          ? widget.rateRes.list[index].authorName ?? 'Anonymous'
                          : 'Anonymous'}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                          widget.rateRes.list[index].rate.toString(),
                        ),
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 14,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      Text(
                        widget.rateRes.list[index].review ?? '',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                useFul(
                                  widget.rateRes.list[index].author.toString(),
                                  !widget.rateRes.list[index].disable,
                                );
                              },
                              icon: Icon(widget.rateRes.list[index].disable
                                  ? Icons.favorite
                                  : Icons.favorite_outline)),
                          Text(widget.rateRes.list[index].usefulCount
                              .toString()),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.0))),
                                  builder: (BuildContext buildContext) {
                                    return ReplyForm(
                                      serviceName: widget.serviceName,
                                      locationId: widget.id,
                                      authorOfRate:
                                          widget.rateRes.list[index].author ?? '',
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.comment_outlined)),
                          Text(
                            widget.rateRes.list[index].replyCount.toString(),
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
      },
    );
  }
}

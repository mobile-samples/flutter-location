import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/common/widgets/hyberlink.dart';
import 'package:flutter_user/features/company/company_model.dart';
import 'package:flutter_user/features/company/company_service.dart';
import 'package:flutter_user/features/location/widgets/location-form-reply.dart';
import 'package:flutter_user/features/rate/rate_model.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_user/utils/date_utils.dart' as dt;

import '../../rate/rate_service.dart';
import 'review-form.dart';

class ReviewTabWidget extends StatefulWidget {
  ReviewTabWidget({required this.companyID, this.companyInfo});

  String companyID;
  CompanyInfo? companyInfo;

  @override
  State<ReviewTabWidget> createState() => _ReviewTabWidgetState();
}

class _ReviewTabWidgetState extends State<ReviewTabWidget> {
  late SearchResult<RateComment> rateRes;
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    getRateComment();
  }

  getRateComment() async {
    final res = await RateService.instance
        .search('/companies/rates/search', widget.companyID, '-rate');
    setState(() {
      rateRes = res;
      _loading = false;
    });
  }

  postRateFunc<double>(
    List<double> rates,
    String review,
    String time,
    bool anonymous,
  ) async {
    final storage = new FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse(baseUrl +
          '/companies/rates/' +
          widget.companyID +
          '/' +
          (userId ?? '')),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'rates': rates,
        'review': review,
        'time': time,
        'anonymous': anonymous
      }),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  postUseFul(String authorOfRate, bool useful) async {
    final res = await RateService.instance
        .postUseful('companies', widget.companyID, authorOfRate, useful);
    if (res > 0) {
      await getRateComment();
    }
  }

  Widget getCategoriesWidgets(List<String> categories, List<int>? rates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < categories.length; i++) ...[
          SizedBox(width: 0, height: 5),
          DecoratedBox(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(rates != null ? rates[i].toString() : "0"),
                  Icon(Icons.star,
                      color: Theme.of(context).colorScheme.tertiary),
                  Text(categories[i]),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: Colors.white,
            ),
          ),
        ]
      ],
    );
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
      children: [
        SizedBox(width: 0, height: 10),
        Text(widget.companyInfo?.rate?.toStringAsFixed(1) ?? "0.0",
            style: Theme.of(context).textTheme.titleLarge),
        SizedBox(width: 0, height: 10),
        RatingBar.builder(
          initialRating: widget.companyInfo?.rate ?? 0.0,
          minRating: 1,
          direction: Axis.horizontal,
          itemSize: 16,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onRatingUpdate: (rating) {},
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Reviews", style: Theme.of(context).textTheme.titleMedium),
              OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                    builder: (BuildContext buildContext) {
                      return ReviewForm(postRate: postRateFunc);
                    },
                  );
                },
                child: Text('Review'),
              )
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: rateRes.total,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(rateRes.list[index].rate.toString()),
                      RatingBar.builder(
                        initialRating:
                            double.parse(rateRes.list[index].rate.toString()),
                        direction: Axis.horizontal,
                        itemSize: 16,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                  SizedBox(width: 10, height: 0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                rateRes.list[index].anonymous
                                    ? 'Anonymous'
                                    : rateRes.list[index].authorName.toString(),
                                style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(width: 0, height: 5),
                            Text(
                                dt.DateUtils.formatDate(
                                    rateRes.list[index].ratetime.toString()),
                                style: Theme.of(context).textTheme.labelMedium),
                            SizedBox(width: 0, height: 5),
                            Text(rateRes.list[index].review.toString(),
                                style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(width: 0, height: 5),
                            Text("Ratings by category",
                                style: Theme.of(context).textTheme.bodyMedium),
                            getCategoriesWidgets(CompanyService.categories,
                                rateRes.list[index].rates),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      postUseFul(
                                        rateRes.list[index].author.toString(),
                                        !rateRes.list[index].disable,
                                      );
                                    },
                                    icon: Icon(
                                      rateRes.list[index].disable
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_alt_outlined,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    rateRes.list[index].usefulCount.toString(),
                                  ),
                                ],
                              ),
                              getHyberLink("Replies", () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0),
                                    ),
                                  ),
                                  builder: (BuildContext buildContext) {
                                    return ReplyForm(
                                      serviceName: 'companies',
                                      locationId: widget.companyID,
                                      authorOfRate: rateRes.list[index].author,
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

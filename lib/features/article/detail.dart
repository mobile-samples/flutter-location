import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/common/widgets/comments.dart';
import 'package:flutter_user/common/widgets/reviews.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:flutter_user/features/comment/comment_service.dart';
import 'package:flutter_user/features/comment/reaction_comment.dart';
import 'package:flutter_user/features/comment/search_comment.dart';
import 'package:flutter_user/features/rate/rate_model.dart';
import 'package:flutter_user/features/rate/rate_service.dart';
import 'package:flutter_user/features/rate/widgets/rate_form.dart';
import 'package:flutter_user/utils/http_helper.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;

import 'article_model.dart';
import 'article_service.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({Key? key, required this.articleID});

  final articleID;

  @override
  State<StatefulWidget> createState() {
    return _ArticleDetailState();
  }
}

class _ArticleDetailState extends State<ArticleDetail> {
  Article? article;
  late bool _loading = true;
  late SearchResult<RateComment> rateRes;
  final SearchCommentThreadService<CommentThread> searchCommentThreadService =
      SearchCommentThreadClient.instance;
  late SearchResult<CommentThread> commentRes;

  @override
  void initState() {
    super.initState();
    getArticleByID();
    getRates();
    getComments();
  }

  getArticleByID() async {
    final articleRes = await ArticleService.instance.getByID(widget.articleID);
    setState(() {
      this.article = articleRes;
      this._loading = false;
    });
  }

  getRates() async {
    final res = await RateService.instance
        .search('/articles/rates/search', widget.articleID, 'time desc');
    setState(() {
      rateRes = res;
      _loading = false;
    });
  }

  getComments() async {
    final res =
        await searchCommentThreadService.search('articles', widget.articleID);
    setState(() {
      commentRes = res;
      _loading = false;
    });
  }

  postRateFunc<double>(
    double rate,
    String review,
    bool anonymous,
  ) async {
    final storage = new FlutterSecureStorage();
    late String baseUrl = HttpHelper.instance.getUrl();
    final userId = await storage.read(key: 'userId');
    final headers = await HttpHelper.instance.buildHeader();
    final response = await http.post(
      Uri.parse('$baseUrl/articles/rates/${widget.articleID}/${userId ?? ''}'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'rate': int.parse(rate.toString().substring(0, 1)),
        'review': review,
        'time': DateTime.now().toIso8601String(),
        'anonymous': anonymous
      }),
    );
    if (response.statusCode == 200) {
      return 1;
    }
    throw json.decode(response.body)['error']['message'];
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          title: Text("Article"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text(
              this.article?.title ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(width: 0, height: 10),
            Text(
              this.article?.description ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(width: 0, height: 10),
            SizedBox(width: 0, height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(this.article?.content ?? ""),
                    TextButton(
                      style: Theme.of(context).textButtonTheme.style,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)),
                          ),
                          builder: (BuildContext buildContext) {
                            return RateForm(postRate: postRateFunc);
                          },
                        );
                      },
                      child: Text('Post a Review'),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Reviews",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Reviews(
                      id: widget.articleID,
                      serviceName: 'articles',
                      rateRes: rateRes,
                      getRates: getRates,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Comments",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Comments(
                      id: widget.articleID,
                      serviceName: 'articles',
                      load: getArticleByID,
                      searchCommentThreadService:
                          SearchCommentThreadClient.instance,
                      reactionService: ReactionCommentClient.instance,
                      commentThreadService: ArticleCommentThread.instance,
                      commentThreadReplyService:
                          FilmCommentThreadReplyClient.instance,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:flutter_user/features/rate/rate_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_user/features/review/tab_reviews.dart';

import 'package:flutter_user/features/comment/reaction_comment.dart';
import 'package:flutter_user/features/comment/reaction.dart';
import 'package:flutter_user/features/comment/rate_service.dart';
import 'package:flutter_user/features/rate/search_rate.dart';
import 'package:flutter_user/features/comment/search_comment.dart';
import 'package:flutter_user/features/comment/comment_service.dart';

import '../film_model.dart';
import '../film_service.dart';

class FilmDetail extends StatefulWidget {
  const FilmDetail({super.key, required this.id});
  final String id;

  @override
  State<FilmDetail> createState() => _FilmDetailState();
}

class _FilmDetailState extends State<FilmDetail> {
  late Film film;
  late bool _loading = true;
  late final WebViewController controller;

  final ReactionService reactionRateService = ReactionRateClient.instance;
  final ReactionService reactionCommentService = ReactionCommentClient.instance;
  final RateService rateService = RateClient.instance;
  final SearchRateService<RateComment> searchRateService =
      SearchRateClient.instance;
  final RateCommentService rateCommentService = RateReplyClient.instance;
  final SearchCommentThreadService<CommentThread> searchCommentThreadService =
      SearchCommentThreadClient.instance;
  final CommentThreadService commentThreadService =
      FilmCommentThreadClient.instance;
  final CommentThreadReplyService commentThreadReplyService =
      FilmCommentThreadReplyClient.instance;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    final rs = await FilmService.instance.get(widget.id);
    setState(() {
      film = rs;
      _loading = false;
    });
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context)
                .scaffoldBackgroundColor, //change your color here
          ),
          title: const Text("Film"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                fit: StackFit.loose,
                children: [
                  ClipPath(
                    clipper: NewClipper(),
                    child: SizedBox(
                      width: 500,
                      height: 300,
                      child: Image(
                        image: const NetworkImage(
                          'https://aestheticmedicalpractitioner.com.au/wp-content/uploads/2021/06/no-image.jpg',
                        ),
                        fit: BoxFit.cover,
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  Positioned(
                    left: null,
                    top: null,
                    right: null,
                    bottom: 0,
                    child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(film.imageURL ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          color: Colors.white,
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(film.title ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text("2h 30min",
                          style: Theme.of(context).textTheme.titleSmall),
                      CustomChip(options: film.categories ?? [])
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("", style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ],
              ),
              const Divider(),
              if (film.description!.isNotEmpty)
                SubDescTitle(
                    title: 'Overview', content: film.description ?? ''),
              if (film.casts!.isNotEmpty)
                SubDescTitle(
                  title: 'Casting',
                  content: (film.casts ?? []).join(",").toString(),
                ),
              if (film.directors!.isNotEmpty)
                SubDescTitle(
                  title: 'Director',
                  content: (film.directors ?? []).join(",").toString(),
                ),
              if (film.productions!.isNotEmpty)
                SubDescTitle(
                  title: 'Productions',
                  content: (film.productions ?? []).join(",").toString(),
                ),
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabReviews(
                    id: film.id ?? "",
                    info: film.info,
                    load: load,
                    rateRange: 10,
                    reactionRateService: reactionRateService,
                    reactionCommentService: reactionCommentService,
                    rateService: rateService,
                    searchRateService: searchRateService,
                    rateCommentService: rateCommentService,
                    searchCommentThreadService: searchCommentThreadService,
                    commentThreadService: commentThreadService,
                    commentThreadReplyService: commentThreadReplyService,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class NewClipper extends CustomClipper<Path> {
  final double heightFactor;

  NewClipper({this.heightFactor = 90.0});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - heightFactor);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - heightFactor,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CustomChip extends StatefulWidget {
  final List<String> options;

  const CustomChip({super.key, required this.options});

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List<Widget>.generate(
        widget.options.length,
        (int index) {
          return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ChoiceChip(
                label: Text(
                  widget.options[index],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                selectedColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                selected: true,
              ));
        },
      ).toList(),
    );
  }
}

class SubDescTitle extends StatelessWidget {
  const SubDescTitle({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ]),
          ],
        ));
  }
}

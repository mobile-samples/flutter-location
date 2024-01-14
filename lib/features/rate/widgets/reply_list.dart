import 'package:flutter/material.dart';
import 'package:flutter_user/common/models/history_model.dart';
import 'package:flutter_user/features/comment/rate_service.dart';
import 'package:flutter_user/features/review/widgets/plugin_comment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/utils/date_utils.dart' as dt;

import '../rate_model.dart';

class RateReplies extends StatefulWidget {
  const RateReplies(
      {super.key,
      required this.load,
      required this.id,
      required this.authorOfRate,
      required this.rateCommentClient});
  final String id;
  final String authorOfRate;
  final Function load;
  final RateCommentService rateCommentClient;

  @override
  State<RateReplies> createState() => _RateRepliesState();
}

class _RateRepliesState extends State<RateReplies> {
  late List<RateReply> list;
  late bool _loading = true;
  TextEditingController comment = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool anonymous = false;

  @override
  void initState() {
    super.initState();
    getReply();
  }

  getReply() async {
    final res = await widget.rateCommentClient
        .getComments(widget.id, widget.authorOfRate);
    if (res.isNotEmpty) {
      setState(() {
        list = res;
      });
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 80);
      }
    } else {
      list = List.empty();
    }
    setState(() {
      _loading = false;
    });
  }

  postReply<double>() async {
    final date = DateTime.now().toIso8601String();
    final res = await widget.rateCommentClient.comment(
        widget.id, widget.authorOfRate, comment.value.text, date, anonymous);
    if (res > 0) {
      await getReply();
      comment.clear();
      return 1;
    }
    return 0;
  }

  updateComment(String commentId, String comment, bool anonymous) async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res =
        await widget.rateCommentClient.update(commentId, comment, userId!);
    if (res > 0) {
      await widget.load();
    }
  }

  showModelEdit(BuildContext context, String id, String comment) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (BuildContext buildContext) {
          return Positioned(
            bottom: 0,
            child: CommentBox(
              post: (ctm, anonymousu) {
                updateComment(id, ctm, anonymousu);
                Navigator.of(context).pop();
              },
              id: id,
              comment: comment,
              isHiddenAnonymous: true,
              anonymous: false,
            ),
          );
        });
  }

  delete<double>(BuildContext context, String commentId) async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res =
        await widget.rateCommentClient.delete(widget.id, commentId, userId!);
    if (res > 0) {
      await widget.load();
      return 1;
    }
    return 0;
  }

  showModel(BuildContext context, List<Histories> list) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (BuildContext buildContext) {
          return ListHistories(
            list: list,
          );
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
        child: Padding(
      padding: EdgeInsets.only(
          top: MediaQueryData.fromView(View.of(context))
              .padding
              .top),
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Theme.of(context)
                  .colorScheme
                  .background, //change your color here
            ),
            title: const Text('Reply'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                flex: 4,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: list.length,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    RateReply item = list[index];
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(!(item
                                                      .anonymous ??
                                                  false)
                                              ? item.authorURL ?? ''
                                              : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text(
                                            !(item.anonymous ?? false)
                                                ? item.authorName ?? ''
                                                : 'Anonymous',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          dt.DateUtils.formatDate(
                                              item.time ?? ""),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.more_vert),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20.0))),
                                                builder: (BuildContext
                                                    buildContext) {
                                                  return OptionsCommentWidget(
                                                    onDelete: () async {
                                                      delete(context,
                                                          item.commentId ?? "");
                                                    },
                                                    onEdit: () {
                                                      showModelEdit(
                                                          context,
                                                          item.commentId
                                                              .toString(),
                                                          item.comment
                                                              .toString());
                                                    },
                                                    onShowHistory: () {
                                                      showModel(context,
                                                          item.histories ?? []);
                                                    },
                                                  );
                                                });
                                          },
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(item.comment ?? ''),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextField(
                            maxLines: 1,
                            scrollPhysics: const BouncingScrollPhysics(),
                            decoration: InputDecoration(
                              labelText: 'Comment',
                              hintText: 'Enter your reply comment',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                            ),
                            controller: comment,
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Anonymous'),
                              Switch(
                                value: anonymous,
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                onChanged: (bool value) {
                                  setState(() {
                                    anonymous = value;
                                  });
                                },
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.send),
                                style: Theme.of(context).textButtonTheme.style,
                                onPressed: () async {
                                  await postReply();
                                },
                              ),
                            ])
                      ],
                    ),
                  ))
            ],
          )),
    ));
  }
}

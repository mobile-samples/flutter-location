import 'package:flutter/material.dart';
import 'package:flutter_user/common/models/history_model.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:flutter_user/features/comment/comment_service.dart';
import 'package:flutter_user/utils/date_utils.dart' as dt;
import 'package:flutter_user/features/review/widgets/plugin_comment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommentReplyForm extends StatefulWidget {
  const CommentReplyForm(
      {super.key,
      required this.id,
      required this.commentId,
      required this.commentThreadReplyService});
  final String id;
  final String commentId;
  final CommentThreadReplyService commentThreadReplyService;

  @override
  State<CommentReplyForm> createState() => _CommentReplyFormState();
}

class _CommentReplyFormState extends State<CommentReplyForm> {
  late List<CommentReply> list;
  late bool _loading = true;
  TextEditingController comment = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool anonymous = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res = await widget.commentThreadReplyService
        .getComments(widget.commentId, userId);
    if (res.isNotEmpty) {
      setState(() {
        list = res;
      });
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 80);
      }
    } else {
      setState(() {
        list = List.empty();
      });
    }
    _loading = false;
  }

  postReply<double>(String commentText) async {
    final res = await widget.commentThreadReplyService
        .reply(widget.id, widget.commentId, commentText);
    if (res > 0) {
      await load();
      comment.clear();
      return 1;
    }
    return 0;
  }

  updateComment(String commentId, String comment, bool anonymous) async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res = await widget.commentThreadReplyService
        .update(commentId, comment, userId!);
    if (res > 0) {
      await load();
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
    final res = await widget.commentThreadReplyService
        .delete(widget.id, commentId, userId!);
    if (res > 0) {
      await load();
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
                flex: 3,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: list.length,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    CommentReply item = list[index];
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(list[index]
                                            .authorURL ??
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      list[index].authorName ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    dt.DateUtils.formatDate(
                                        list[index].time ?? ""),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
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
                                                      top: Radius.circular(
                                                          20.0))),
                                          builder: (BuildContext buildContext) {
                                            return OptionsCommentWidget(
                                              onDelete: () async {
                                                delete(context,
                                                    item.commentId ?? "");
                                              },
                                              onEdit: () {
                                                showModelEdit(
                                                    context,
                                                    item.commentId.toString(),
                                                    item.comment.toString());
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text(list[index].comment ?? '')],
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ),
              const Divider(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      CommentBox(
                        post: (commentText, anonymousu) {
                          postReply(commentText);
                        },
                        id: widget.id,
                        comment: "",
                        isHiddenAnonymous: true,
                        anonymous: false,
                      )
                    ],
                  ))
            ],
          )),
    ));
  }
}

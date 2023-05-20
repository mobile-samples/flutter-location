import 'package:flutter/material.dart';
import 'package:flutter_user/models/comment.dart';
import 'package:flutter_user/services/comment.dart';
import 'package:flutter_user/widget-helpers/date_utils.dart' as dt;
import 'package:flutter_user/widgets/reviews/components/plugin_comment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/models/history.dart';

class CommentReplyForm extends StatefulWidget {
  const CommentReplyForm(
      {Key? key,
      required this.id,
      required this.commentId,
      required this.commentThreadReplyService})
      : super(key: key);
  final id;
  final commentId;
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
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res = await widget.commentThreadReplyService
        .getComments(widget.commentId, userId);
    if (res.length > 0) {
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
    final storage = new FlutterSecureStorage();
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
        shape: RoundedRectangleBorder(
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
    final storage = new FlutterSecureStorage();
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
        shape: RoundedRectangleBorder(
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
          valueColor: new AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(
          top: MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
              .padding
              .top),
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Theme.of(context)
                  .colorScheme
                  .background, //change your color here
            ),
            title: Text('Reply'),
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
                          padding: EdgeInsets.all(10),
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
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      list[index].authorName ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    dt.DateUtils.formatDate(
                                        list[index].time ?? ""),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
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
                                padding: EdgeInsets.all(5),
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
              Divider(),
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

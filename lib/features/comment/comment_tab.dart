import 'package:flutter/material.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:flutter_user/features/comment/comment_service.dart';
import 'package:flutter_user/features/comment/search_comment.dart';
import 'package:flutter_user/features/comment/reaction.dart';
import 'package:flutter_user/features/comment/reply/comment_thread_form.dart';
import 'package:flutter_user/features/comment/comment_item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommentTab extends StatefulWidget {
  const CommentTab(
      {Key? key,
      required this.id,
      required this.load,
      required this.searchCommentThreadService,
      required this.reactionService,
      required this.commentThreadService,
      required this.commentThreadReplyService})
      : super(key: key);
  final String id;
  final Function load;
  final SearchCommentThreadService<CommentThread> searchCommentThreadService;
  final ReactionService reactionService;
  final CommentThreadService commentThreadService;
  final CommentThreadReplyService commentThreadReplyService;

  @override
  State<CommentTab> createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  late SearchResult<CommentThread> r;
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    final r1 = await widget.searchCommentThreadService.search(widget.id);
    setState(() {
      r = r1;
      _loading = false;
    });
  }

  postComment<double>(String comment, bool anonymous) async {
    final res = await widget.commentThreadService.comment(widget.id, comment);
    if (res > 0) {
      await load();
      await widget.load();
      return 1;
    }
    return 0;
  }

  useFul(String commentId, String author) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res =
        await widget.reactionService.setUseful(commentId, author, userId);
    if (res > 0) {
      await load();
    }
  }

  deleteUseFul(String commentId, String author) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res =
        await widget.reactionService.removeUseful(commentId, author, userId);
    if (res > 0) {
      await load();
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
      crossAxisAlignment: CrossAxisAlignment.end,
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
                  return CommentThreadForm(post: postComment);
                });
          },
          child: Text('Comment'),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: r.list.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CommentItem(
                  item: r.list[index],
                  load: load,
                  commentThreadReplyService: widget.commentThreadReplyService,
                  commentThreadService: widget.commentThreadService,
                  useFul: useFul,
                  deleteUseFul: deleteUseFul,
                );
              }),
        )
      ],
    );
  }
}

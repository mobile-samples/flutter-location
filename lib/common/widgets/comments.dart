import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/features/comment/comment_item.dart';
import 'package:flutter_user/features/comment/comment_model.dart';
import 'package:flutter_user/features/comment/comment_service.dart';
import 'package:flutter_user/features/comment/reaction.dart';
import 'package:flutter_user/features/comment/reply/comment_thread_form.dart';
import 'package:flutter_user/features/comment/search_comment.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, 
    required this.id,
    required this.serviceName,
    required this.load,
    required this.searchCommentThreadService,
    required this.reactionService,
    required this.commentThreadService,
    required this.commentThreadReplyService,
  });

  final String id;
  final String serviceName;
  final Function load;
  final SearchCommentThreadService<CommentThread> searchCommentThreadService;
  final ReactionService reactionService;
  final CommentThreadService commentThreadService;
  final CommentThreadReplyService commentThreadReplyService;

  @override
  State<StatefulWidget> createState() {
    return _CommentsState();
  }
}

class _CommentsState extends State<Comments> {
  late SearchResult<CommentThread> res;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    final r = await widget.searchCommentThreadService
        .search(widget.serviceName, widget.id);
    setState(() {
      res = r;
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
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res =
        await widget.reactionService.setUseful(commentId, author, userId);
    // final res = await widget.reactionService
    //     .setUseful(widget.serviceName, commentId, author, userId);
    if (res > 0) {
      await load();
    }
  }

  deleteUseFul(String commentId, String author) async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final res =
        await widget.reactionService.removeUseful(commentId, author, userId);
    // final res = await widget.reactionService
    //     .removeUseful(widget.serviceName, commentId, author, userId);
    if (res > 0) {
      await load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
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
                  return CommentThreadForm(post: postComment);
                });
          },
          child: const Text('Comment'),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: res.list.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CommentItem(
              item: res.list[index],
              load: load,
              commentThreadReplyService: widget.commentThreadReplyService,
              commentThreadService: widget.commentThreadService,
              useFul: useFul,
              deleteUseFul: deleteUseFul,
            );
          },
        )
      ],
    );
  }
}

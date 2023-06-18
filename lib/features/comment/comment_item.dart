import 'package:flutter_user/common/models/history_model.dart';
import 'package:flutter_user/features/review/notifications.dart';
import 'package:flutter_user/features/review/widgets/plugin_comment.dart';
import 'package:flutter_user/features/comment/reply/comment_reply_list.dart';
import 'package:avatars/avatars.dart';
import 'package:flutter_user/utils/date_utils.dart' as dt;
import 'package:flutter/material.dart';
import 'package:flutter_user/features/comment/comment_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/features/comment/comment_model.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key? key,
    required this.item,
    required this.commentThreadReplyService,
    required this.commentThreadService,
    required this.load,
    required this.useFul,
    required this.deleteUseFul,
  }) : super(key: key);
  final CommentThread item;

  final Function load;
  final Function useFul;
  final Function deleteUseFul;
  final CommentThreadReplyService commentThreadReplyService;
  final CommentThreadService commentThreadService;

  updateComment(String commentId, String comment) async {
    final storage = new FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    print("update");
    print(commentId + comment + userId!);
    final res = await commentThreadService.update(commentId, comment, userId!);
    if (res > 0) {
      await load();
    }
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

  showModelEdit(
      BuildContext context, String id, String comment, bool anonymous) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (BuildContext buildContext) {
          return CommentBox(
            post: (commentu, anonymousu) async {
              await updateComment(id, commentu);
              Navigator.of(context).pop(false);
            },
            id: id,
            comment: comment,
            isHiddenAnonymous: true,
            anonymous: false,
          );
        });
  }

  Future<void> delete(BuildContext context, String commentId) async {
    if (await confirm(
      context,
      title: const Text('Confirm'),
      content: const Text('Would you like to remove?'),
      textOK: const Text('Yes'),
      textCancel: const Text('No'),
    )) {
      final storage = new FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      final res = await commentThreadService.delete(commentId, userId!);
      if (res > 0) {
        await load();
      } else {
        await alert(
          context,
          isError: true,
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: IntrinsicHeight(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      item.authorURL!.length > 0
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(item.authorURL ?? ''),
                            )
                          : Avatar(
                              name: item.authorName ?? "",
                              shape: AvatarShape.circle(22.0)),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(item.authorName ?? "",
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                      Spacer(),
                      Text(
                        dt.DateUtils.formatDate(item.time ?? ""),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0))),
                              builder: (BuildContext buildContext) {
                                return OptionsCommentWidget(
                                  onDelete: () async {
                                    delete(context, item.commentId ?? "");
                                  },
                                  onEdit: () {
                                    showModelEdit(
                                        context,
                                        item.commentId.toString(),
                                        item.comment.toString(),
                                        item.anonymous ?? false);
                                  },
                                  onShowHistory: () {
                                    showModel(context, item.histories ?? []);
                                  },
                                );
                              });
                        },
                      )
                    ]),
                    Container(
                      margin: EdgeInsets.only(left: 45.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    item.comment ?? "",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (!(item.disable ?? false)) {
                                          useFul(
                                            item.commentId ?? "",
                                            item.author ?? '',
                                          );
                                        } else {
                                          deleteUseFul(
                                            item.commentId ?? "",
                                            item.author ?? '',
                                          );
                                        }
                                      },
                                      icon: Icon(item.disable ?? false
                                          ? Icons.favorite
                                          : Icons.favorite_outline)),
                                  Text((item.usefulCount ?? 0).toString())
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20.0))),
                                            builder:
                                                (BuildContext buildContext) {
                                              return CommentReplyForm(
                                                id: item.id,
                                                commentId: item.commentId,
                                                commentThreadReplyService:
                                                    commentThreadReplyService,
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.comment_outlined)),
                                  Text((item.replyCount ?? 0).toString())
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ))),
    );
  }
}

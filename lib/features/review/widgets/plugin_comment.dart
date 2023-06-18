import 'package:flutter/material.dart';
import 'package:flutter_user/common/models/history_model.dart';
import 'package:flutter_user/utils/date_utils.dart' as dt;

class ListHistories extends StatelessWidget {
  const ListHistories({
    Key? key,
    required this.list,
  }) : super(key: key);
  final List<Histories> list;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        child: list.length == 0
            ? ListTile(
                title: Text("No data"),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                          trailing: Text(
                              dt.DateUtils.formatDate(list[index].time ?? "")),
                          subtitle: Text(list[index].comment.toString())));
                }));
  }
}

class CommentBox extends StatefulWidget {
  const CommentBox({
    Key? key,
    required this.post,
    this.id,
    required this.comment,
    required this.isHiddenAnonymous,
    required this.anonymous,
  }) : super(key: key);

  final Function post;
  final dynamic id;
  final String comment;
  final bool isHiddenAnonymous;
  final bool anonymous;

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  TextEditingController comment = TextEditingController();
  bool anonymous = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    comment.text = widget.comment;
  }

  dynamic validator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!widget.isHiddenAnonymous) Text('Anonymous'),
                if (!widget.isHiddenAnonymous)
                  Switch(
                    value: anonymous,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (bool value) {
                      setState(() {
                        anonymous = value;
                      });
                    },
                  ),
                if (!widget.isHiddenAnonymous) Spacer(),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      minLines: 1,
                      maxLines: 3,
                      scrollPhysics: BouncingScrollPhysics(),
                      decoration: InputDecoration(
                        labelText: 'Comment',
                        hintText: 'Enter your comment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      controller: comment,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  style: Theme.of(context).textButtonTheme.style,
                  onPressed: () async {
                    await widget.post(comment.text.toString(), anonymous);
                    Navigator.of(context).pop();
                  },
                ),
              ])
        ],
      ),
    );
  }
}

class OptionsCommentWidget extends StatelessWidget {
  final Function onEdit;
  final Function onDelete;
  final Function onShowHistory;

  const OptionsCommentWidget({
    Key? key,
    required this.onDelete,
    required this.onEdit,
    required this.onShowHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView(children: [
        GestureDetector(
            onTap: () {
              this.onShowHistory();
            },
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
            )),
        GestureDetector(
            onTap: () {
              this.onEdit();
            },
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            )),
        GestureDetector(
            onTap: () {
              this.onDelete();
            },
            child: ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Remove'),
            )),
      ]),
    );
  }
}

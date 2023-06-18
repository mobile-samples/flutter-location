import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentThreadForm extends StatefulWidget {
  const CommentThreadForm({Key? key, required this.post}) : super(key: key);
  final Function post;
  @override
  State<CommentThreadForm> createState() => _CommentThreadFormState();
}

class _CommentThreadFormState extends State<CommentThreadForm> {
  TextEditingController review = TextEditingController();
  bool anonymous = false;

  postHandle(BuildContext context) async {
    final res = await widget.post(review.value.text, anonymous);
    if (res > 0) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 460,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: Theme.of(context).textButtonTheme.style,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                  TextButton(
                    style: Theme.of(context).textButtonTheme.style,
                    onPressed: () async {
                      await postHandle(context);
                    },
                    child: Text('Post'),
                  ),
                ],
              ),
              Divider(),
              Card(
                color: Theme.of(context).colorScheme.background,
                child: TextField(
                  controller: review,
                  maxLines: 8, //or null
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

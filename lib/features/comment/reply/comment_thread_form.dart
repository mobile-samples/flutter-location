import 'package:flutter/material.dart';

class CommentThreadForm extends StatefulWidget {
  const CommentThreadForm({super.key, required this.post});
  final Function post;
  @override
  State<CommentThreadForm> createState() => _CommentThreadFormState();
}

class _CommentThreadFormState extends State<CommentThreadForm> {
  TextEditingController review = TextEditingController();
  bool anonymous = false;

  postHandle(BuildContext context) async {
    final res = await widget.post(review.value.text, anonymous);
    if (!context.mounted) return;
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
          padding: const EdgeInsets.all(10),
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
                    child: const Text('Done'),
                  ),
                  TextButton(
                    style: Theme.of(context).textButtonTheme.style,
                    onPressed: () async {
                      await postHandle(context);
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
              const Divider(),
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

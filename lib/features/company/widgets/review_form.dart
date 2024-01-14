import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_user/common/widgets/dialog.dart';

import '../company_service.dart';

class ReviewForm extends StatefulWidget {
  const ReviewForm({super.key, required this.postRate});
  final Function postRate;

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  TextEditingController reviewText = TextEditingController();
  late List<double> rates = [0.0, 0.0, 0.0, 0.0, 0.0];

  postRateHandle(BuildContext context) async {
    bool isRate = true;
    for (var rate in rates) {
      if (rate == 0.0) {
        isRate = false;
        break;
      }
    }
    if (!isRate || reviewText.value.text == "") {
      return showDialogWithMsg(
          context, 'Alert', 'Please input your rate / review');
    }
    final date = DateTime.now().toIso8601String();
    final res =
        await widget.postRate(rates, reviewText.value.text, date, false);
    if (!context.mounted) return;
    if (res > 0) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
                TextButton(
                  onPressed: () async {
                    await postRateHandle(context);
                  },
                  child: const Text('Post'),
                ),
              ],
            ),
            const Divider(),
            for (var i = 0; i < CompanyService.categories.length; i++) ...[
              Text(CompanyService.categories[i]),
              RatingBar.builder(
                initialRating: rates[i],
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 30,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rates[i] = rating;
                  });
                },
              ),
              const SizedBox(width: 0, height: 5),
              const Divider(),
            ],
            Card(
              color: Theme.of(context).colorScheme.background,
              child: TextField(
                controller: reviewText,
                maxLines: 8, //or null
              ),
            ),
          ],
        ),
      ),
    );
  }
}

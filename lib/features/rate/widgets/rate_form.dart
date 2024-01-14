import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateForm extends StatefulWidget {
  const RateForm({super.key, required this.postRate});
  final Function postRate;
  @override
  State<RateForm> createState() => _RateFormState();
}

class _RateFormState extends State<RateForm> {
  TextEditingController review = TextEditingController();
  late double rate = 0;
  bool anonymous = false;

  postRateHandle(BuildContext context) async {
    final res = await widget.postRate(rate, review.value.text, anonymous);
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
                      await postRateHandle(context);
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
              const Divider(),
              RatingBar.builder(
                initialRating: rate,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 10,
                itemSize: 30,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rate = rating;
                  });
                },
              ),
              Card(
                color: Theme.of(context).colorScheme.background,
                child: TextField(
                  controller: review,
                  maxLines: 8, //or null
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Anonymous'),
                  Switch(
                    value: anonymous,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (bool value) {
                      setState(() {
                        anonymous = value;
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

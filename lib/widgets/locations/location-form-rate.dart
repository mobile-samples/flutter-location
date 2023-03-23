import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateForm extends StatefulWidget {
  const RateForm({Key? key, required this.postRate}) : super(key: key);
  final Function postRate;
  @override
  State<RateForm> createState() => _RateFormState();
}

class _RateFormState extends State<RateForm> {
  TextEditingController review = TextEditingController();
  late double rate = 0;
  bool anonymous = true;

  postRateHandle(BuildContext context) async {
    final res = await widget.postRate(rate, review.value.text, anonymous);
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
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.green,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                  Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.green,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      await postRateHandle(context);
                    },
                    child: Text('Post'),
                  ),
                ],
              ),
              Divider(),
              RatingBar.builder(
                initialRating: rate,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 30,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rate = rating;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      controller: review,
                      maxLines: 8, //or null
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Anonymous'),
                    Switch(
                      value: anonymous,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        setState(() {
                          anonymous = value;
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

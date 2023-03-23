import 'package:flutter/material.dart';
import 'package:flutter_user/models/rate.dart';
import 'package:flutter_user/services/rate.dart';

class ReplyForm extends StatefulWidget {
  const ReplyForm(
      {Key? key, required this.locationId, required this.authorOfRate})
      : super(key: key);
  final locationId;
  final authorOfRate;
  @override
  State<ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyForm> {
  late List<RateReply> listReply;
  late bool _loading = true;
  TextEditingController comment = TextEditingController();
  bool anonymous = true;
  @override
  void initState() {
    super.initState();
    getReply();
  }

  getReply() async {
    final res = await RateService.instance
        .getReplyofRate(widget.locationId, widget.authorOfRate);
    if (res.length > 0) {
      setState(() {
        listReply = res;
        _loading = false;
      });
    }
  }

  postReply<double>() async {
    final date = DateTime.now().toIso8601String();
    final res = await RateService.instance.postReply(widget.locationId,
        widget.authorOfRate, comment.value.text, date, anonymous);
    if (res > 0) {
      await getReply();
      comment.clear();
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
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
              color: Colors.white, //change your color here
            ),
            title: Text('Reply'),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: listReply.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(!listReply[index]
                                        .anonymous
                                    ? listReply[index].userURL ?? ''
                                    : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                            !listReply[index].anonymous
                                                ? listReply[index].authorName ??
                                                    ''
                                                : 'Anonymous',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Text(
                                          listReply[index].time!.split('T')[0],
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    ),
                                    Text(listReply[index].comment ?? '')
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      controller: comment,
                      maxLines: 1, //or null
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
                    ),
                    Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.green,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        await postReply();
                      },
                      child: Text('Reply'),
                    ),
                  ],
                ),
              )
            ],
          )),
    ));
  }
}

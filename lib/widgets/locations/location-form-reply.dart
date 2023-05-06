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
  final ScrollController scrollController = ScrollController();
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
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 80);
      }
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: new AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
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
              color: Theme.of(context)
                  .colorScheme
                  .background, //change your color here
            ),
            title: Text('Reply'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                flex: 4,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: listReply.length,
                  shrinkWrap: true,
                  controller: scrollController,
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
                                    ? listReply[index].authorURL ?? ''
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
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
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Card(
                        color: Theme.of(context).colorScheme.background,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: TextField(
                            controller: comment,
                            maxLines: 1, //or null
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Anonymous'),
                          Switch(
                            value: anonymous,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (bool value) {
                              setState(() {
                                anonymous = value;
                              });
                            },
                          ),
                          Spacer(),
                          TextButton(
                            style: Theme.of(context).textButtonTheme.style,
                            onPressed: () async {
                              await postReply();
                            },
                            child: Text('Reply'),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          )),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_user/features/job/model.dart';
import 'package:flutter_user/features/job/service.dart';

class JobDetail extends StatefulWidget {
  const JobDetail({Key? key, required this.id});

  static const routeName = '/jobDetail';

  final String id;

  @override
  State<StatefulWidget> createState() {
    return _JobDetailState();
  }
}

class _JobDetailState extends State<JobDetail> {
  Job? data;
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    getByID();
  }

  getByID() async {
    final res = await JobService.instance.load(widget.id);
    setState(() {
      this.data = res;
      this._loading = false;
    });
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          title: Text("Job"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text(
              this.data?.title ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(width: 0, height: 10),
            Text(
              this.data?.description ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

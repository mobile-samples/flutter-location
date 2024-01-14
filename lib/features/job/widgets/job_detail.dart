import 'package:flutter/material.dart';
import 'package:flutter_user/common/widgets/custom_appbar.dart';
import 'package:flutter_user/features/job/job_model.dart';
import 'package:flutter_user/features/job/Job_service.dart';

class JobDetail extends StatefulWidget {
  const JobDetail({super.key, required this.id});

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
      data = res;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBarWithArrowBack(context, data?.title ?? ''),
        body: Column(
          children: [
            Text(
              data?.title ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 0, height: 10),
            Text(
              data?.description ?? '',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

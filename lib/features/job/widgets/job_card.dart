import 'package:flutter/material.dart';
import 'package:flutter_user/features/job/job_model.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.data});

  final Job data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://static.vecteezy.com/system/resources/previews/008/214/517/large_2x/abstract-geometric-logo-or-infinity-line-logo-for-your-company-free-vector.jpg"),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  Text(
                    data.benefit,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  )
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}

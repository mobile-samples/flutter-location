import 'package:flutter/material.dart';
import 'package:flutter_user/features/job/model.dart';

class JobCard extends StatelessWidget {
  const JobCard({Key? key, required this.data}) : super(key: key);

  final Job data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          // Expanded(
          //   flex: 1,
          //   child: CircleAvatar(
          //     backgroundImage: (data.imageURL == null || data.imageURL!.isEmpty)
          //         ? null
          //         : NetworkImage(data.imageURL.toString()),
          //   ),
          // ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  Text(
                    data.benifit,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}

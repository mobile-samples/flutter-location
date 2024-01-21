import 'package:flutter/material.dart';
import 'package:flutter_user/common/widgets/app_size.dart';

import '../user_model.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.userInfo});
  final UserInfo userInfo;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image(
              width: 150,
              height: 150,
              image: NetworkImage(userInfo.imageURL ??
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png'),
              fit: BoxFit.fitHeight,
            ),
            spaceWidth(20),
            Expanded(
              child: Column(
                children: [
                  Text(userInfo.username ?? ''),
                  spaceHeight(20),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    children: userInfo.skills != null
                        ? userInfo.skills!.map((e) {
                            return Chip(label: Text(e.skill ?? ''));
                          }).toList()
                        : [],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

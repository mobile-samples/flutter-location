import 'package:flutter/material.dart';
import 'package:flutter_user/models/user.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({Key? key, required this.userInfo}) : super(key: key);
  final UserInfo userInfo;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: double.maxFinite,
      width: 150,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(userInfo.imageURL ??
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png'),
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: Text(
                userInfo.username ?? '',
              ),
            )
          ],
        ),
      ),
    );
  }
}

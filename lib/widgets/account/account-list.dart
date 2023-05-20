import 'package:flutter/material.dart';
import 'package:flutter_user/models/search.dart';
import 'package:flutter_user/models/user.dart';
import 'package:flutter_user/services/user.dart';
import 'package:flutter_user/widgets/account/account-card.dart';
import 'package:flutter_user/widgets/account/account.dart';

class AccountListWidget extends StatefulWidget {
  const AccountListWidget({Key? key}) : super(key: key);

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {
  late List<UserInfo> listUser = [];

  @override
  void initState() {
    super.initState();
    searchUser();
  }

  searchUser() async {
    final res = await UserService.instance.searchUser(Filter(24, 1));
    setState(() {
      listUser = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (listUser.length > 0)
                GridView.builder(
                    shrinkWrap: true,
                    itemCount: listUser.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountWidget(
                                        userId: listUser[index].id ?? '',
                                      )));
                        },
                        child: AccountCard(userInfo: listUser[index]),
                      );
                    })
            ],
          ),
        ),
      ),
    );
  }
}

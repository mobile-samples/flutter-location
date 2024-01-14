import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/common/widgets/dialog.dart';
import 'package:flutter_user/features/account/user_service.dart';

import '../user_model.dart';
import 'basic_form.dart';
import 'setting.dart';
import 'skill.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key, required this.userId});
  final String userId;
  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  UserInfo? userInfo;
  late String? myUserId = "";
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getUserId();
  }

  getUserInfo() async {
    final res = await UserService.instance.getUserInfo(widget.userId);
    setState(() {
      userInfo = res;
    });
  }

  getUserId() async {
    const storage = FlutterSecureStorage();
    final userIdFromStore = await storage.read(key: 'userId');
    if (userIdFromStore != '') {
      setState(() {
        myUserId = userIdFromStore;
      });
    }
  }

  saveInfo(BuildContext context, UserInfo userInfo) async {
    SaveResult<UserInfo> res = await UserService.instance.saveInfo(userInfo);
    if (!context.mounted) return;
    if (res.status > 0) {
      setState(() {
        userInfo = res.value;
      });
      showDialogWithMsg(context, 'Success', 'Save info success');
    } else {
      showDialogWithMsg(context, 'Fail', 'Save info fail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context)
                .scaffoldBackgroundColor, //change your color here
          ),
          title: const Text("Profile"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 210,
              child: Stack(
                children: [
                  Image(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                    image: NetworkImage(userInfo?.coverURL ??
                        'https://aestheticmedicalpractitioner.com.au/wp-content/uploads/2021/06/no-image.jpg'),
                  ),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingWidget()));
                          },
                          icon: const Icon(Icons.settings))),
                  Positioned(
                    top: 75,
                    left: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userInfo?.imageURL ??
                          'https://aestheticmedicalpractitioner.com.au/wp-content/uploads/2021/06/no-image.jpg'),
                    ),
                  )
                ],
              ),
            ),
            Text(
              userInfo?.givenname ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people),
                Text("1"),
                SizedBox(width: 10),
                Icon(Icons.person_add),
                Text("1")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Card(
                    color: const Color.fromARGB(255, 246, 246, 246),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_box),
                                const Text("Basic Info"),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BasicInfoForm(
                                                    userInfo: userInfo!,
                                                    saveInfo: saveInfo,
                                                  )));
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
                            const Divider(),
                            Text(userInfo?.occupation ?? ''),
                            Text(userInfo?.company ?? '')
                          ]),
                    ),
                  ),
                  Card(
                    color: const Color.fromARGB(255, 246, 246, 246),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_box),
                                const Text("Skills"),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SkillsWidget(
                                                    userInfo: userInfo!,
                                                    saveInfo: saveInfo,
                                                  )));
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
                            const Divider(),
                            Text(userInfo?.skills
                                    ?.map((e) => e.skill)
                                    .join(', ')
                                    .toString() ??
                                ''),
                          ]),
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter_user/common/client/client.dart';
import 'package:flutter_user/common/client/model.dart';
import 'package:flutter_user/common/client/search_state.dart';
// import 'package:flutter_user/common/models/search.dart';
import 'package:flutter_user/common/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../user_model.dart';
import '../user_service.dart';
import 'account_card.dart';
import 'account.dart';

class AccountListWidget extends StatefulWidget {
  const AccountListWidget({super.key});

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends SearchState<AccountListWidget, UserInfo, UserFilter> {
  late List<UserInfo> listUser = [];

  late UserFilter filter;

  @override
  UserFilter getFilter() {
    return filter;
  }

  @override
  Client<UserInfo, String, UserFilter> getService() {
    return UserService.instance;
  }

  @override
  void setFilter() {
    setState(() {
      filter = UserFilter(20, 1);
    });
  }

  gotoDetail(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountWidget(userId: id)));
  }

  @override
  PreferredSizeWidget buildAppbar(BuildContext context) {
    return getAppBarWithoutArrowBack(
      context, AppLocalizations.of(context)!.job_list_title);
  }

   @override
  Widget buildChild(BuildContext context, SearchResult<UserInfo> searchResult) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (searchResult.list.isNotEmpty) {
                return GestureDetector(
                    onTap: () {
                      gotoDetail(searchResult.list[index].id!);
                    },
                    child: AccountCard(
                      userInfo: searchResult.list[index],
                    ));
              } else {
                return Container();
              }
            },
            childCount: searchResult.list.length,
          ),
        ),
      ],
    );
  }
}

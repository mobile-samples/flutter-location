import 'package:flutter/material.dart';
import 'package:flutter_user/common/widgets/autocomplete-custom.dart';
import 'package:flutter_user/features/account/user_service.dart';

import '../user_model.dart';

class SkillsWidget extends StatefulWidget {
  const SkillsWidget({Key? key, required this.userInfo, required this.saveInfo})
      : super(key: key);
  final UserInfo userInfo;
  final Function saveInfo;
  @override
  State<SkillsWidget> createState() => _SkillsWidgetState();
}

class _SkillsWidgetState extends State<SkillsWidget> {
  late UserInfo userInfo;
  @override
  void initState() {
    super.initState();
    setState(() {
      userInfo = widget.userInfo;
    });
  }

  loadOptions(String keyword) async {
    List<String> options = await UserService.instance.getSkills(keyword);
    return options;
  }

  getSkillsSelected(List<String> selected) {
    setState(() {
      userInfo.skills = selected.map((e) => Skills(skill: e)).toList();
    });
  }

  saveInfo(BuildContext context) async {
    await widget.saveInfo(userInfo, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Skills'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: AutoCompleteCustom(
                  selected: widget.userInfo.skills!.length > 0
                      ? widget.userInfo.skills!
                          .map((e) => e.skill.toString())
                          .toList()
                      : [],
                  loadOptions: loadOptions,
                  callbackFn: getSkillsSelected,
                ),
                flex: 10,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      saveInfo(context);
                    },
                    child: Text("Save")),
                flex: 1,
              )
            ],
          )),
    ));
  }
}

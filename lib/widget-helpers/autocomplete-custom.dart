import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_user/services/user.dart';
import 'package:flutter_user/widget-helpers/dot-loading/dot-loading.dart';

class AutoCompleteCustom extends StatefulWidget {
  const AutoCompleteCustom(
      {Key? key,
      required this.selected,
      required this.loadOptions,
      required this.callbackFn})
      : super(key: key);
  final List<String> selected;
  final Function loadOptions;
  final Function callbackFn;
  @override
  State<AutoCompleteCustom> createState() => _AutoCompleteCustomState();
}

class _AutoCompleteCustomState extends State<AutoCompleteCustom> {
  Timer debounceTimer = Timer(Duration.zero, () {});
  final TextEditingController textFieldController = TextEditingController();
  List<String> suggestions = [];
  List<String> selected = [];
  List<String> filteredSuggestions = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      selected = widget.selected;
    });
  }

  Future<List<String>> getFilteredSuggestions(String query) async {
    List<String> filtered = [];
    if (query.isNotEmpty) {
      List<String> options =
          await UserService.instance.getSkills(textFieldController.value.text);
      filtered = options
          .where((option) =>
              option.toLowerCase().startsWith(query.toLowerCase()) &&
              !selected.contains(option))
          .toList();
    }
    return filtered;
  }

  Widget buildTextField() {
    return TextField(
      controller: textFieldController,
      decoration: InputDecoration(
          hintText: "Type here...",
          suffixIcon: loading
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: DotLoadingIndicator(color: Colors.green),
                )
              : IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      selected.add(textFieldController.text);
                      filteredSuggestions = [];
                    });
                    widget.callbackFn(selected);
                    textFieldController.clear();
                  },
                )),
      onChanged: (value) {
        if (debounceTimer != null) {
          debounceTimer.cancel();
        }
        setState(() {
          loading = true;
        });
        debounceTimer = Timer(Duration(milliseconds: 500), () async {
          List<String> options = await getFilteredSuggestions(value);
          setState(() {
            filteredSuggestions = options;
            loading = false;
          });
        });
      },
    );
  }

  @override
  void dispose() {
    if (debounceTimer != null) {
      debounceTimer.cancel();
    }
    super.dispose();
  }

  Widget buildSuggestionsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredSuggestions[index]),
          onTap: () {
            setState(() {
              selected.add(filteredSuggestions[index]);
              filteredSuggestions = [];
            });
            widget.callbackFn(selected);
            textFieldController.clear();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: selected.map((option) {
            return Chip(
              label: Text(option),
              onDeleted: () {
                setState(() {
                  selected.remove(option);
                });
                widget.callbackFn(selected);
              },
            );
          }).toList(),
        ),
        buildTextField(),
        Expanded(child: buildSuggestionsList()),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'client.dart';
import 'model.dart';

abstract class SearchState<W extends StatefulWidget, T, S extends Filter>
    extends State<W> {
  late Future<SearchResult<T>> searchResult;

  @protected
  void setFilter();

  @protected
  S getFilter();

  @protected
  Client<T, String, ResultInfo<T>, S> getService();

  @protected
  PreferredSizeWidget buildAppbar(BuildContext context);

  @protected
  Widget buildChild(BuildContext context, SearchResult<T> searchResult);

  @override
  void initState() {
    super.initState();
    setFilter();
    search();
  }

  void search() {
    final filter = getFilter();
    final res = getService().search(true, false, filter);
    setState(() {
      searchResult = res;
      this.setFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: FutureBuilder<SearchResult<T>>(
          future: searchResult,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildChild(context, snapshot.data!);
            } else if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot get data')));
              });
              return buildChild(context, SearchResult(0, []));
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
            );
          }),
    );
  }
}

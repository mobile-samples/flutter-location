import 'package:flutter/material.dart';

import '../film_model.dart';
import '../film_service.dart';
import 'film-detail.dart';
import 'film_card.dart';

class FilmListWidget extends StatefulWidget {
  const FilmListWidget({Key? key}) : super(key: key);

  @override
  State<FilmListWidget> createState() => _FilmListWidgetState();
}

class _FilmListWidgetState extends State<FilmListWidget> {
  late List<Film> films;
  late int total;
  bool _loading = true;
  late TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    load();
    _textController = TextEditingController(text: '');
  }

  load() async {
    final res = await FilmService.instance.search();
    setState(() {
      print(res);
      films = res.list;
      total = res.total;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        valueColor: new AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary),
      ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Search Locations",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          body: Column(children: [
            // CupertinoSearchTextField(controller: _textController),
            Container(
              margin: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Search...'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(_isList ? Icons.grid_view : Icons.list),
                    color: const Color.fromARGB(255, 18, 16, 16),
                    iconSize: 32.0,
                    splashRadius: 24.0,
                    onPressed: () {
                      setState(() {
                        _isList = !_isList;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: getView()),
          ]));
    }
  }

  bool _isList = true;

  Widget getView() {
    if (_isList) {
      return getListWidget(); // Returns a list view widget
    } else {
      return getGridWidget(); // Returns a Grid view widget
    }
  }

  Widget getListWidget() {
    return ListView.builder(
      itemCount: films.length,
      itemBuilder: (BuildContext context, int index) {
        return FilmCard(
          isList: true,
          film: films[index],
          onTab: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilmDetail(id: films[index].id)));
          },
        );
      },
    );
  }

  Widget getGridWidget() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return FilmCard(
          isList: false,
          film: films[index],
          onTab: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilmDetail(id: films[index].id)));
          },
        );
      },
      itemCount: films.length,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'article_model.dart';
import 'article_service.dart';
import 'detail.dart';

class ArticleListWidget extends StatefulWidget {
  const ArticleListWidget({super.key});

  @override
  State<ArticleListWidget> createState() => _ArticleListWidgetState();
}

class _ArticleListWidgetState extends State<ArticleListWidget> {
  late List<Article> articles;
  late int total;
  bool _loading = true;
  late TextEditingController _searchArticlesController;

  @override
  void initState() {
    super.initState();
    _searchArticlesController = TextEditingController(text: '');
    searchArticles(null);
  }

  searchArticles(String? text) async {
    final res = await ArticleService.instance.search(text);
    setState(() {
      articles = res.list;
      total = res.total;
      _loading = false;
    });
  }

  gotoArticleDetail(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetail(articleID: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 0, height: 20),
            Text(
              "Search articles",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CupertinoSearchTextField(
              controller: _searchArticlesController,
              onSubmitted: (textInput) {
                searchArticles(textInput);
              },
              onSuffixTap: () {
                _searchArticlesController.clear();
                searchArticles(null);
              },
            ),
            const SizedBox(width: 0, height: 20),
            Text("Articles", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(width: 0, height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: articles.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    gotoArticleDetail(articles[i].id);
                  },
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  articles[i].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(width: 0, height: 10),
                                Text(
                                  articles[i].description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

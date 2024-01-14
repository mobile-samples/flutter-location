import 'package:flutter/material.dart';

import '../film_model.dart';

class FilmCard extends StatelessWidget {
  const FilmCard(
      {super.key, required this.isList, required this.film, required this.onTab});
  final Film film;
  final Function onTab;
  final bool isList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTab();
                },
        child: SizedBox(
          height: 200,
          width: 250,
          //square box; equal height and width so that it won't look like oval
          child: isList
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          film.imageURL ??
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png',
                          fit: BoxFit.cover,
                          width: 150,
                          height: 200,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Text(
                              film.title ?? '',
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              softWrap: false,
                            ),
                            Text(
                              (film.categories ?? []).join(",").toString(),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          film.imageURL ??
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 150,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            film.title ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            softWrap: false,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
}

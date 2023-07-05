import 'package:examen_final/ui/anime_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyAnimes());
}

class MyAnimes extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My animes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimeList()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:examen_final/util/db_helper.dart';
import 'package:examen_final/models/anime.dart';

class FavAnimes extends StatefulWidget {
  const FavAnimes({super.key});

  @override
  State<FavAnimes> createState() => _FavAnimesState();
}

class _FavAnimesState extends State<FavAnimes> {
  DbHelper dbHelper = DbHelper();
  List<Anime> animes = [];

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Animes'),
      ),
      body: ListView.builder(
        itemCount: (animes != null) ? animes.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage('${animes[index].image}'),
              ),
              title: Text(animes[index].title!),
              onTap: () {},
              trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await dbHelper.deleteAnime(animes[index]);
                    setState(() {
                      animes.removeAt(index);
                    });
                  }),
            ),
          );
        },
      ),
    );
  }

  Future showData() async {
    await dbHelper.openDb();
    animes = await dbHelper.getAnimes();
    print(animes.length);
    setState(() {
      animes = animes;
    });
  }
}

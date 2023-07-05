import 'package:examen_final/ui/preferences_dialog.dart';
import 'package:flutter/material.dart';
import 'package:examen_final/util/db_helper.dart';
import 'package:examen_final/models/anime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavAnimes extends StatefulWidget {
  const FavAnimes({super.key});

  @override
  State<FavAnimes> createState() => _FavAnimesState();
}

class _FavAnimesState extends State<FavAnimes> {
  DbHelper dbHelper = DbHelper();
  List<Anime> animes = [];
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {

    showData();
    PrefencesDialog dialog = PrefencesDialog();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Animes'),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: <Widget>[
                const Text('See Preferences'),
                IconButton(
                  icon: const Icon(Icons.numbers),
                  onPressed: () {
                    //mostra el dialog asincrono
                    print('Members: ${prefs.getInt('members')}');
                    print('Episodes: ${prefs.getInt('episodes')}');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            dialog.buildDialog(context, prefs.getInt('members')!.toInt(), prefs.getInt('episodes')!.toInt())
                    );
                  },
                ),
              ],

            ),
          ),],
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
              subtitle: Text(
                  '${animes[index].year} - ${animes[index].members} - ${animes[index].episodes}'
              ),
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
    prefs = await SharedPreferences.getInstance();
    await dbHelper.openDb();
    animes = await dbHelper.getAnimes();
    //print(animes.length);
    setState(() {
      animes = animes;
    });
  }
}

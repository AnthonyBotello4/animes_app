import 'package:flutter/material.dart';
import 'package:examen_final/util/db_helper.dart';
import 'package:examen_final/util/http_helper.dart';

import '../models/anime.dart';
import 'favorites_anime_list.dart';


class AnimeList extends StatefulWidget {
  const AnimeList({Key? key}) : super(key: key);

  @override
  State<AnimeList> createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  late List<Anime> animes;
  late int animesCount;

  int page = 1;
  bool loading = true;
  late HttpHelper helper;
  ScrollController? _scrollController;

  Future initialize() async{
    animes = <Anime>[];
    loadMore();
    initScrollController();
    animes = (await helper.getUpcoming('1'))!;
    // setState(() {
    //   moviesCount = movies.length;
    //   movies = movies;
    // });
  }
  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: <Widget>[
                const Text('See Favorites'),
                IconButton(
                  icon: const Icon(Icons.favorite_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) =>
                          FavAnimes()
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemCount: animes.length,
          itemBuilder: (BuildContext context, int index){
            return AnimeRow(animes[index]);
          }),
    );
  }

  void loadMore(){
    helper.getUpcoming(page.toString()).then((value) {
      animes += value!;
      setState(() {
        animesCount = animes.length;
        animes = animes;
        page++;
      });

      if (animes.length % 20 > 0){
        setState(() {
          loading = false;
        });
      }
    });
  }

  void initScrollController(){
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if ((_scrollController!.position.pixels ==
          _scrollController!.position.maxScrollExtent)
          && loading){
        loadMore();
      }
    });
  }
}

class AnimeRow extends StatefulWidget {

  final Anime anime;
  AnimeRow(this.anime);

  @override
  _AnimeRowState createState() => _AnimeRowState(anime);
}

class _AnimeRowState extends State<AnimeRow> {

  final Anime anime;
  _AnimeRowState(this.anime);
  bool favorite = false;
  DbHelper dbHelper = DbHelper();
  String path = '';

  @override
  void initState() {
    favorite = false;
    dbHelper = DbHelper();
    isFavorite(anime);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted){
      super.setState(fn);
    }
  }

  Future isFavorite(Anime anime) async {
    await dbHelper.openDb();
    favorite = await dbHelper.isFavorite(anime);
    setState(() {
      anime.isFavorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {

    isFavorite(anime);

    if (anime.image != null){
      path = '${anime.image}';
    } else {
      path = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png';
    }

    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: Hero(
          tag: "poster_${widget.anime.id}",
          child: CircleAvatar(
            backgroundImage: NetworkImage(path),
          ),
        ),
        title: Text(widget.anime.title!),
        subtitle: Text(
            '${widget.anime.year} - ${widget.anime.members} - ${widget.anime.episodes}'
        ),
        onTap: (){
        },
        trailing: IconButton(
          icon: const Icon(Icons.favorite),
          color: favorite ? Colors.red : Colors.grey,
          onPressed: (){
            favorite
                ? dbHelper.deleteAnime(anime)
                : dbHelper.insertAnime(anime);
            setState(() {
              favorite = !favorite;
              anime.isFavorite = favorite;
            });
          },
        ),
      ),
    );
  }
}
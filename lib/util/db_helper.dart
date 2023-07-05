import 'package:examen_final/models/anime.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  final int version = 1;
  Database? db;

  static final DbHelper dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null){
      db = await openDatabase(
          join(await getDatabasesPath(), 'anime.db'),
          onCreate: (database, version){
            database.execute(
                'CREATE TABLE animes('
                    'id INTEGER PRIMARY KEY, image TEXT, title TEXT, year TEXT)'
            );
          },
          version: version
      );
    }

    return db!;
  }

  //obtener todas las peliculas
  Future<List<Anime>> getAnimes() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await db!.query('animes');
    return List.generate(maps.length, (i){
      return Anime(
          id: maps[i]['id'],
          title: maps[i]['title'],
          year: stringToInt(maps[i]['year']),
          images: maps[i]['image'],
          isFavorite: true
      );
    });
  }

  Future<int?> insertAnime(Anime anime) async {
    int? id = await db!.insert(
        'animes',
        anime.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id;
  }

  int? stringToInt(String num){
    int? number = int.tryParse(num);
    return number;
  }

  Future<bool> isFavorite(Anime anime) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        'animes',
        where: 'id = ?',
        whereArgs: [anime.id]
    );
    return maps.length > 0;
  }

  Future<int> deleteAnime(Anime anime) async {
    int result = await db!.delete(
        'animes',
        where: 'id = ?',
        whereArgs: [anime.id]
    );
    return result;
  }

}
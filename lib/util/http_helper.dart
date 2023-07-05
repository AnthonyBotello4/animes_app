import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class HttpHelper{
  final String urlBase = 'https://api.jikan.moe/v4/top/anime';
  // final String urlUpcoming = '/upcoming?';
  // final String urlKey = 'api_key=3cae426b920b29ed2fb1c0749f258325';
  final String urlPage = '?page=';


  Future<List<Anime>?> getUpcoming(String page) async {
    final String upcoming = urlBase + urlPage + page;// + urlUpcoming + urlKey + urlPage + page;
    http.Response result = await http.get(Uri.parse(upcoming));
    if (result.statusCode == HttpStatus.ok){
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['data'];
      List<Anime> movies = moviesMap.map<Anime>((i) => Anime.fromJson(i)).toList();
      return movies;
    } else {
      print(result.body);
      return null;
    }
  }

}
import 'dart:async';
import 'package:movies/src/models/actors_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesProvider {
  String _apiKey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'en-US ';

  int _trendingNowPage = 0;
  bool _loading = false;

  List<Movie> _trending = new List();

  final _trendingStreamController = StreamController<List<Movie>>.broadcast();

  // Sirve para añadir nuevas películas al stream
  Function(List<Movie>) get trendingSink => _trendingStreamController.sink.add;
  // Para escuchar peliculas añadidas
  Stream<List<Movie>> get trendingStream => _trendingStreamController.stream;

//método para cerrar streams
  void disposeStreams() {
    _trendingStreamController?.close();
  }

  Future<List<Movie>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final movies = Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getInTheaters() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Movie>> getTrendingNow() async {
    if (_loading) return [];
    _loading = true;
    _trendingNowPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'languge': _language,
      'page': _trendingNowPage.toString()
    });
    // procesa la data recibida del API
    final resp = await _procesarRespuesta(url);

    //Añade las nuevas peliculas del stream a la seccion de "trending now"
    _trending.addAll(resp);
    //Para colocar las nuevas pelicula al inicio del stream de datos
    trendingSink(_trending);
    _loading = false;
// Devuelve la lista de peliculas añadidas
    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apiKey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }
 
 Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }

}

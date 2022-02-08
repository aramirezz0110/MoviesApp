import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/credits_response.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/models/now_playing_response.dart';
import 'package:peliculas_app/models/popular_response.dart';
import 'package:peliculas_app/models/search_movies_response.dart';

class MovieProvider extends ChangeNotifier {
  String _apiKey = 'c1b1923b35f2a0975af4fdac8cbc2d80';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';
  //para el infinite scroll
  int _popularPage = 0;
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  //mapa para tener en memoria el casting ya cargado
  Map<int, List<Cast>> moviesCast = {};
  final debouncer = Debouncer(duration: Duration(milliseconds: 500));
  //para el caso de los streams, .broadcast() para dar a conocer a los que dependen de la info
  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  //definicion del stream
  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;
  MovieProvider() {
    print('Movie proovider started');
    getOnDisplayMovies();
    getPopularMovies();
  }
  getOnDisplayMovies() async {
    // print('getOnDisplayMovies');
    // //estructura de la url de petución
    // //parametros ('dominio base', 'segmento', 'parametros del query')
    // final url = Uri.https(_baseUrl, '3/movie/now_playing',
    //     {'api_key': _apiKey, 'language': _language, 'page': '1'});
    // //peticion de informacion
    // final response = await http.get(url);

    final jsonData = await _getJsonData('3/movie/now_playing');
    //ya con los datos obtenidos
    //print(response.body);
    //desde el modelo
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    //avisar que existen cambios
    notifyListeners();
  }

  getPopularMovies() async {
    // print('getPopularMovies');
    // //estructura de la url de petución
    // //parametros ('dominio base', 'segmento', 'parametros del query')
    // final url = Uri.https(_baseUrl, '3/movie/popular',
    //     {'api_key': _apiKey, 'language': _language, 'page': '1'});
    // //peticion de informacion
    // final response = await http.get(url);
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    //ya con los datos obtenidos
    //print(response.body);
    //desde el modelo
    final popularMoviesResponse = PopularResponse.fromJson(jsonData);
    //para concatenar resultados
    popularMovies = [...popularMovies, ...popularMoviesResponse.results];
    //print(popularMovies);
    //avisar que existen cambios
    notifyListeners();
  }

  //optimizacion de codigo
  Future<String> _getJsonData(String endPoint, [int page = 1]) async {
    //estructura de la url de petución
    //parametros ('dominio base', 'segmento', 'parametros del query')
    final url = Uri.https(_baseUrl, endPoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    final response = await http.get(url);
    return response.body;
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //para que devuelva la info ya cargada, para realizar la peticion por id solo una vez
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  //para la busqueda
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  //para emitir el valor de la busqueda al query para el stream
  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resuls = await this.searchMovies(value);
      //emitir el valor hacia el stream
      this._suggestionStreamController.add(resuls);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });
    //cancelar timer si se recibbe un valor
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}

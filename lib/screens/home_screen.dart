import 'package:flutter/material.dart';
import 'package:peliculas_app/models/now_playing_response.dart';
import 'package:peliculas_app/providers/movie_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //instanciacion de escucha de los datos
    //parametros (contexto, 'listen=true  le dice al widget que se redibuje en caso de algun cambio')
    final moviesProvider = Provider.of<MovieProvider>(context);
    //print(moviesProvider.onDisplayMovies);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Peliculas en cines")),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MovieSearchDelegate());
              },
              icon: Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Card Swipper, que espera a la info de las movies
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            //Listado horizontal de peliculas
            MovieSlider(
              popularMovies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () {
                moviesProvider.getPopularMovies();
              },
            )
          ],
        ),
      ),
    );
  }
}

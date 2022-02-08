import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  //sobreescribir el contenido del placeholder
  @override
  String get searchFieldLabel => 'Buscar película';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  //contenido de los resultados cuando se clickea en enter
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    return Container();
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 100,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    //para los datos del provider
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.getSuggestionsByQuery(query);
    return StreamBuilder(
      stream: movieProvider.suggestionStream,
      //future: movieProvider.searchMovies(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();
        final movies = snapshot.data!;
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) {
              return _movieitem(movie: movies[index], context: context);
            });
      },
    );
  }

  Widget _movieitem({required Movie movie, required BuildContext context}) {
    return ListTile(
      leading: FadeInImage(
        placeholder: AssetImage("assets/no-image.jpg"),
        image: NetworkImage(movie.fullPosterImg),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: movie);
      },
    );
  }
}

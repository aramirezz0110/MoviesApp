import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> popularMovies;
  final Function onNextPage;
  String? title;
  MovieSlider({
    Key? key,
    required this.popularMovies,
    this.title,
    required this.onNextPage,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  //para el estado del scroll
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    //para escucha del estado
    scrollController.addListener(() {
      //scrollController.position.maxScrollExtent, para saber el espacio de scroll total
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        //llamar a cargar mas elementos de provider
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (widget.popularMovies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.35,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: size.height * 0.35,
      //color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.title == null)
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.popularMovies.length,
              itemBuilder: (_, int index) {
                final size = MediaQuery.of(context).size;
                return _MoviePoster(
                    size: size, movie: widget.popularMovies[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  const _MoviePoster({
    Key? key,
    required this.size,
    required this.movie,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(5),
      width: size.width * 0.3,
      height: size.height * 0.8,
      //color: Colors.green,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: movie);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage("assets/no-image.jpg"),
                image: NetworkImage(movie.fullPosterImg),
                height: size.height * 0.25,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

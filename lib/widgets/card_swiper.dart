import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //para obtener las dimensiones de la pantalla
    final size = MediaQuery.of(context).size;
    if (movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.indigo,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      //color: Colors.red,
      child: Swiper(
        itemCount: movies.length, //cantidad de tarjetas
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (BuildContext context, int index) {
          //para obtener cada pelicula de la lista
          final movie = movies[index];
          //print(movie.fullPosterImg);
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: movie);
            },
            child: Hero(
              tag: movie.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(movie.fullPosterImg),
                  //para que la imagen se adapte al contenedor
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

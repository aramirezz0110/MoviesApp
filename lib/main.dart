import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';

void main() => runApp(AppState());

//creacion de la referencia
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //lazy=false es para crear la instancia de provider al crearse el widget, por defecto esta en 'true'
        ChangeNotifierProvider(
          create: (_) => MovieProvider(),
          lazy: false,
        )
      ],
      child: MyApp(),
    );
  }
}

//contenido de la app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/home',
      routes: {
        '/home': (_) => HomeScreen(),
        '/details': (_) => DetailsScreen()
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(color: Colors.indigoAccent),
      ),
    );
  }
}

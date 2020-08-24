import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.30,
      //page view builder para evitar fuga de memoria
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemCount: movies.length,
        itemBuilder: (context, index) => _crearTarjeta(context, movies[index]),
      ),
    );
  }

  Widget _crearTarjeta(BuildContext context, Movie movies) {
    movies.uniqueId = '${movies.id}-poster';
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movies.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(movies.getPosterImg()),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            movies.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).accentTextTheme.caption,
          )
        ],
      ),
    );
    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movies);
      },
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return movies.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).accentTextTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}

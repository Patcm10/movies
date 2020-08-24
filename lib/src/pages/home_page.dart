import 'package:flutter/material.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    moviesProvider.getTrendingNow(); 
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Movieland', style: TextStyle(color: Colors.black),
          ),
          //backgroundColor: Colors.yellow[700],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: () {
                //Para el buscador
                showSearch(
                  context: context, 
                  delegate: DataSearch(),
                  //query: 'Search'
                  );
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(),
              _footer(context),
            ],
          ),
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: moviesProvider.getInTheaters(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Trending Now',
                  style:  Theme.of(context).accentTextTheme.subtitle1)),
          SizedBox(height: 14.0),
          StreamBuilder(
            stream: moviesProvider.trendingStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              //snapshot.data?.forEach((element) => print(element.title)); **Para saber el titulo de cada pelicula. ? significa hacer el forEach si existe data
              if (snapshot.hasData) {
                return MovieHorizontal(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getTrendingNow,
                  );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

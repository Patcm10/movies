import 'package:flutter/material.dart';
import 'package:movies/src/models/actors_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(context, movie),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0),
              _posterTitulo(context, movie),
              _description(movie),
              _description(movie),
              _description(movie),
              _description(movie),
              _createCasting(movie),
            ]),
          )
        ],
      ),
    );
  }

  Widget _crearAppBar(BuildContext context, Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
        backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/no-image.jpg'),
          image: NetworkImage(movie.getBackgroundImg()),
          fadeInDuration: Duration(seconds: 2),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(movie.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis),
              Text(movie.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis),
              Row(
                children: <Widget>[
                  Icon(Icons.star_border),
                  Text(movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(movie.overview, textAlign: TextAlign.justify),
    );
  }

  Widget _createCasting(Movie movie) {
    final movieProvider = new MoviesProvider();

    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return createActoresPageView(snapshot
              .data); //snapshot.data es la lista completa de los actores
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget createActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, index) => _actorTarjeta(actores[index]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              image: NetworkImage(actor.getFoto()),
              height: 150.0,
              fit: BoxFit.cover,
              ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

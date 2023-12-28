
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:cinelyric/screens/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Movie {
  final String quote;
  final String name;
  final String date;
  final String genre;
  final String posterUrl;

  Movie(
      {required this.quote,
      required this.name,
      required this.date,
      required this.genre,
      required this.posterUrl});
}

class Music {
  final String name;
  final String date;
  final String genre;
  final String album;
  final String singer;
  final String singerPhotoUrl;

  Music(
      {required this.name,
      required this.date,
      required this.genre,
      required this.album,
      required this.singer,
      required this.singerPhotoUrl});
}

class ResultHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Result Details',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Use ListView.builder for scrollable cards
            Expanded(
              child: ListView.builder(
                itemCount: 1, // Change this to the number of cards you want
                itemBuilder: (context, index) {
                  return MovieCard(
                    movie: Movie(
                      quote: context.watch<MovieProvider>().quote,
                      name: context.watch<MovieProvider>().movie,
                      date: context.watch<MovieProvider>().year,
                      genre: context.watch<MovieProvider>().type,
                      posterUrl:
                          'https://m.media-amazon.com/images/I/61RhWaYBp7L._AC_SL1044_.jpg',
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: MyAppBottomBar(),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MovieDetails(movie: movie),
      ),
    );
  }
}

class MovieDetails extends StatelessWidget {
  final Movie movie;

  MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Quote: ${movie.quote}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Movie Name: ${movie.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Release Date: ${movie.date}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Type: ${movie.genre}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        // Image.network(
        //   movie.posterUrl,
        //   width: 100,
        //   height: 150,
        //   fit: BoxFit.cover,
        // ),
      ],
    );
  }
}
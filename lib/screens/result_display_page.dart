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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('CineLyric App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Result Details',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Example Movie Details
              MovieDetails(
                movie: Movie(
                  quote: context.watch<MovieProvider>().quote,
                  name: context.watch<MovieProvider>().movie,
                  date: context.watch<MovieProvider>().year,
                  genre: context.watch<MovieProvider>().type,
                  posterUrl:
                      'https://m.media-amazon.com/images/I/61RhWaYBp7L._AC_SL1044_.jpg',
                ),
              ),
              SizedBox(height: 20),
              // Example Music Details
              // MusicDetails(
              //   music: Music(
              //     name: 'Shape of You',
              //     date: '2017',
              //     genre: 'Pop',
              //     album: 'Divide',
              //     singer: 'Ed Sheeran',
              //     singerPhotoUrl:
              //         'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Ed_Sheeran-6886_%28cropped%29.jpg/440px-Ed_Sheeran-6886_%28cropped%29.jpg',
              //   ),
              // ),
            ],
          ),
        ),
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

// class MusicDetails extends StatelessWidget {
//   final Music music;

//   MusicDetails({required this.music});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Song Name: ${music.name}'),
//               Text('Release Date: ${music.date}'),
//               Text('Genre: ${music.genre}'),
//               Text('Album: ${music.album}'),
//               Text('Singer: ${music.singer}'),
//             ],
//           ),
//         ),
//         SizedBox(width: 20),
//         Image.network(
//           music.singerPhotoUrl,
//           width: 100,
//           height: 150,
//           fit: BoxFit.cover,
//         ),
//       ],
//     );
//   }
// }

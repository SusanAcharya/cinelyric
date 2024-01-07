// import 'package:cinelyric/elements/appbar.dart';
// import 'package:cinelyric/elements/bottombar.dart';
// import 'package:cinelyric/screens/movie_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class Movie {
//   final String quote;
//   final String name;
//   final String date;
//   final String genre;
//   final String posterUrl;
//
//   Movie(
//       {required this.quote,
//       required this.name,
//       required this.date,
//       required this.genre,
//       required this.posterUrl});
// }
//
// class Music {
//   final String name;
//   final String date;
//   final String genre;
//   final String album;
//   final String singer;
//   final String singerPhotoUrl;
//
//   Music(
//       {required this.name,
//       required this.date,
//       required this.genre,
//       required this.album,
//       required this.singer,
//       required this.singerPhotoUrl});
// }
//
// class ResultHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Result Details',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 3, // Change this to the number of cards you want
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: MovieCard(
//                       movie: Movie(
//                         quote: context.watch<MovieProvider>().quote,
//                         name: context.watch<MovieProvider>().movie,
//                         date: context.watch<MovieProvider>().year,
//                         genre: context.watch<MovieProvider>().type,
//                         posterUrl:
//                             'https://m.media-amazon.com/images/I/61RhWaYBp7L._AC_SL1044_.jpg',
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//       bottomNavigationBar: MyAppBottomBar(),
//     );
//   }
// }
//
// class MovieCard extends StatelessWidget {
//   final Movie movie;
//
//   MovieCard({required this.movie});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: MovieDetails(movie: movie),
//       ),
//     );
//   }
// }
//
// class MovieDetails extends StatelessWidget {
//   final Movie movie;
//
//   MovieDetails({required this.movie});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Quote: ${movie.quote}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 20.0,
//                   ),
//                 ),
//                 Text(
//                   'Movie Name: ${movie.name}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 20.0,
//                   ),
//                 ),
//                 Text(
//                   'Release Date: ${movie.date}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 20.0,
//                   ),
//                 ),
//                 Text(
//                   'Type: ${movie.genre}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.normal,
//                     fontSize: 20.0,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(width: 20),
//         // Image.network(
//         //   movie.posterUrl,
//         //   width: 100,
//         //   height: 150,
//         //   fit: BoxFit.cover,
//         // ),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';

class MovieResult extends StatefulWidget {
  final String query;

  MovieResult({required this.query});

  @override
  _MovieResultState createState() => _MovieResultState();
}

class _MovieResultState extends State<MovieResult> {
  String token = "";
  List<Movie> movies = [];

  late Future<void> dataFetchingFuture;

  @override
  void initState() {
    super.initState();
    dataFetchingFuture = getDataFromSharedPreferences().then((_) {
      return getMovies();
    });
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    token = stringValue!;
    print('String value: $token');
  }

  Future<void> getMovies() async {
    String apiUrl = 'http://10.0.2.2:8000/movie/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> requestBody = {
      'quote': widget.query,
    };
    String jsonBody = jsonEncode(requestBody);
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedData = jsonDecode(response.body);

        movies = decodedData.map((data) => Movie.fromJson(data)).toList();

        print('Movies: $movies');
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jasonBody = jsonDecode(response.body);
        String message = jasonBody['message'];
        print(message);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Api response: $message'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Builder(
        builder: (context) {
          return FutureBuilder<void>(
            future: dataFetchingFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Results for your input:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          Movie movie = movies[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Name: ${movie.movie}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${movie.type}'),
                                  Text('Release Date ${movie.year}'),
                                  Text('Your query: "${widget.query}"'),
                                ],
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: const MyAppBottomBar(),
    );
  }
}

class Movie {
  final int id;
  final String quote;
  final String movie;
  final String type;
  final String year;

  Movie({
    required this.id,
    required this.quote,
    required this.movie,
    required this.type,
    required this.year,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      quote: json['quote'],
      movie: json['movie'],
      type: json['type'],
      year: json['year'],
    );
  }
}
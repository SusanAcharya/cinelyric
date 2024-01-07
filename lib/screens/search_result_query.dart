// import 'dart:convert';
// import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
// import 'package:cinelyric/elements/appbar.dart';
// import 'package:cinelyric/elements/bottombar.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SearchQueryResult extends StatefulWidget {
//   final String query;
//
//   SearchQueryResult({required this.query});
//
//   @override
//   _SearchQueryResultState createState() => _SearchQueryResultState();
// }
//
// class _SearchQueryResultState extends State<SearchQueryResult> {
//   String token = "";
//   int id = 0;
//   String quote = 'default';
//   String movie = 'default';
//   String type = 'default';
//   String year = 'default';
//
//   late Future<void> dataFetchingFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     dataFetchingFuture = getDataFromSharedPreferences().then((_) {
//       return getMovie();
//     });
//   }
//
//   Future<void> getDataFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? stringValue = prefs.getString('token');
//     token = stringValue!;
//     print('String value: $token');
//   }
//
//   Future<void> getMovie() async {
//     String apiUrl = 'http://10.0.2.2:8000/movie/';
//     Map<String, String> headers = {
//       'Authorization': 'Token $token',
//       'Content-Type': 'application/json',
//     };
//     Map<String, dynamic> requestBody = {
//       'quote': widget.query,
//     };
//     String jsonBody = jsonEncode(requestBody);
//     try {
//       http.Response response = await http.post(
//         Uri.parse(apiUrl),
//         headers: headers,
//         body: jsonBody,
//       );
//
//       if (response.statusCode == 200) {
//         Map<String, dynamic> decodedData = jsonDecode(response.body);
//         id = decodedData['id'];
//         quote = decodedData['quote'];
//         movie = decodedData['movie'];
//         type = decodedData['type'];
//         year = decodedData['year'];
//
//         print('ID: $id');
//         print('Quote: $quote');
//         print('Movie: $movie');
//         print('Type: $type');
//         print('Year: $year');
//       } else {
//         print('Failed with status code: ${response.statusCode}');
//         print('Response: ${response.body}');
//         Map<String, dynamic> jasonBody = jsonDecode(response.body);
//         String message = jasonBody['message'];
//         print(message);
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const MyAppBar(),
//       body: Builder(
//         builder: (context) {
//           return FutureBuilder<void>(
//             future: dataFetchingFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return Column(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'We found this information for your query:',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: 1,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             margin: const EdgeInsets.all(8.0),
//                             child: ListTile(
//                               title: Text('Name: $movie'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Type: $type'),
//                                   Text('Release Date $year'),
//                                   Text('Your query: "${widget.query}"'),
//                                 ],
//                               ),
//                               onTap: () {},
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               }
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: const MyAppBottomBar(),
//     );
//   }
// }
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';

class SearchQueryResult extends StatefulWidget {
  final String query;

  SearchQueryResult({required this.query});

  @override
  _SearchQueryResultState createState() => _SearchQueryResultState();
}

class _SearchQueryResultState extends State<SearchQueryResult> {
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
                        'We found this information for your query:',
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


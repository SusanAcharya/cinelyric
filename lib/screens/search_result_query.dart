import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:cinelyric/elements/movie.dart';

import 'movie_info.dart';

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
    // String apiUrl = 'https://3140-2400-1a00-b040-1115-2d7f-ac13-bf4c-a684.ngrok-free.app/movie/';
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
                                  Text('Movie Quote: "${movie.quote}"')
                                ],
                              ),
                              // leading: movie.poster_link == ""
                              //     ? Image.network(
                              //   'https://icons.iconarchive.com/icons/designbolts/free-multimedia/512/Film-icon.png',
                              //   width: 80.0,
                              //   height: 150.0,
                              //   fit: BoxFit.cover,
                              // )
                              //     : Image.network(
                              //   movie.poster_link,
                              //   width: 80.0,
                              //   height: 150.0,
                              //   fit: BoxFit.cover,
                              // ),
                              leading: movie.poster_link == ""
                                  ? Image.network(
                                      'https://icons.iconarchive.com/icons/designbolts/free-multimedia/512/Film-icon.png',
                                      width: 80.0,
                                      height: 150.0,
                                      fit: BoxFit.cover,
                                    )
                                  : FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/placeholder/Film-icon.png', // Placeholder image
                                      image: movie.poster_link,
                                      width: 80.0,
                                      height: 150.0,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        // Handle image loading errors here
                                        return Image.asset(
                                          'assets/placeholder/Film-icon.png', // Error placeholder image
                                          width: 80.0,
                                          height: 150.0,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MovieInfo(movie: movie),
                                  ),
                                );
                              },
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
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 1),
    );
  }
}

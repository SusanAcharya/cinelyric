import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'music_provider.dart';


// Import statements...

class SearchQueryResultMusic extends StatefulWidget {
  final String query;

  SearchQueryResultMusic({required this.query});

  @override
  _SearchQueryResultState createState() => _SearchQueryResultState();
}

class _SearchQueryResultState extends State<SearchQueryResultMusic> {
  String token = "";
  String id = '0';
  String artist = 'default';
  String track = 'default';
  String genre = 'default';
  String year = 'default';
  String lyric = 'default';

  late Future<void> dataFetchingFuture;

  @override
  void initState() {
    super.initState();
    dataFetchingFuture = getDataFromSharedPreferences().then((_) {
      return getMusic();
    });
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    token = stringValue!;
    print('String value: $token');
  }
  Future getMusic() async {
    //getDataFromSharedPreferences();
    String apiUrl = 'http://10.0.2.2:8000/song/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json', // Specify content type as JSON
    };
    Map<String, dynamic> requestBody = {
      'lyric': widget.query,
    };
    String jsonBody = jsonEncode(requestBody);
    try {
      // Send the POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Request was successful
        print('Response: ${response.body}');
        Map<String, dynamic> decodedData = jsonDecode(response.body);
        //int id = decodedData['id'];
        id = decodedData['id'].toString();
        artist = decodedData['artist_name'];
        track = decodedData['track_name'];
        genre = decodedData['genre'];
        lyric = decodedData['lyrics'];
        year = decodedData['release_date'].toString();

        print('ID: $id');
        print('artist: $artist');
        print('track: $track');
        print('type: $genre');
        print('Year: $year');


      } else {
        // Request failed
        print('Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jasonBody = jsonDecode(response.body);
        String message = jasonBody['message'];
        print(message);
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
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
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Track_Name: $track'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Artist: $artist'),
                                  Text('Genre: $genre'),
                                  Text('Release Date $year'),
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


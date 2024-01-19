import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';

import '../elements/music.dart';
import 'music_info.dart';

class MusicResult extends StatefulWidget {
  final String query;

  MusicResult({required this.query});

  @override
  _MusicResultState createState() => _MusicResultState();
}

class _MusicResultState extends State<MusicResult> {
  String token = "";
  List<Music> music = [];

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
    // String apiUrl =
    //     'https://8cd5-2400-1a00-b040-5496-7491-c660-170c-1ab5.ngrok-fre/song/';
    String apiUrl = 'http://10.0.2.2:8000/song/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> requestBody = {
      'lyric': widget.query,
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

        music = decodedData.map((data) => Music.fromJson(data)).toList();

        print('Music: $music');
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
                        itemCount: music.length,
                        itemBuilder: (context, index) {
                          Music musics = music[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Name: ${musics.track_name}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Artist: ${musics.artist_name}'),
                                  Text('Genre: ${musics.genre}'),
                                  Text('Release Date: ${musics.release_date}'),
                                  Text('Your query: "${widget.query}"'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MusicInfo(music: musics),
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
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 2),
    );
  }
}

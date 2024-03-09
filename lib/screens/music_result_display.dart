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

enum SortOption { artistNameAscending, artistNameDescending, popularity }

class _MusicResultState extends State<MusicResult> {
  String token = "";
  List<Music> music = [];
  List<Music> defaultOrderMusic = []; // Store the default order

  late Future<void> dataFetchingFuture;
  SortOption selectedSortOption = SortOption.popularity;

  void onSortOptionChanged(SortOption? value) {
    if (value != null) {
      setState(() {
        selectedSortOption = value;
        sortMusic();
      });
    }
  }

  void sortMusic() {
    switch (selectedSortOption) {
      case SortOption.artistNameAscending:
        music.sort((a, b) => a.artist_name.compareTo(b.artist_name));
        break;
      case SortOption.artistNameDescending:
        music.sort((a, b) => b.artist_name.compareTo(a.artist_name));
        break;
      case SortOption.popularity:
        // Reset to the default order
        music = List.from(defaultOrderMusic);
        break;
    }
  }

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
    //String apiUrl = 'http://10.0.2.2:8000/song/';
    String apiUrl = 'http://65.2.9.109:8000/song/';
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
        defaultOrderMusic = List.from(music); // Store the default order

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
                // Sort music based on the selected option
                sortMusic();
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
                    ), // Dropdown menu for sorting options
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<SortOption?>(
                        value: selectedSortOption,
                        items: [
                          DropdownMenuItem(
                            value: SortOption.artistNameAscending,
                            child: Text('Date Ascending'),
                          ),
                          DropdownMenuItem(
                            value: SortOption.artistNameDescending,
                            child: Text('Date Descending'),
                          ),
                          DropdownMenuItem(
                            value: SortOption.popularity,
                            child: Text('Popularity'),
                          ),
                        ],
                        onChanged: onSortOptionChanged,
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
                              title: Text(
                                'Name: ${musics.track_name}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Artist: ${musics.artist_name}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Album: ${musics.album.isNotEmpty ? musics.album : '(single)'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Your query: "${widget.query}"',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              leading: musics.artist_image.isNotEmpty
                                  ? FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/placeholder/music-icon.jpeg',
                                      image: musics.artist_image,
                                      width: 80.0,
                                      height: 180.0,
                                      fit: BoxFit.fill,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/placeholder/music-icon.jpeg',
                                          width: 80.0,
                                          height: 500.0,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/placeholder/music-icon.jpeg',
                                      width: 80.0,
                                      height: 500.0,
                                      fit: BoxFit.fill,
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

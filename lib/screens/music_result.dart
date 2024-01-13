// import 'package:cinelyric/elements/appbar.dart';
// import 'package:cinelyric/elements/bottombar.dart';
// import 'package:cinelyric/screens/music_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// class Music {
//   final String track_name;
//   final String year;
//   final String genre;
//   final String lyrics;
//   final String singer;
//   final String singerPhotoUrl;
//
//   Music(
//       {required this.track_name,
//         required this.year,
//         required this.genre,
//         required this.lyrics,
//         required this.singer,
//         required this.singerPhotoUrl});
// }
//
// class ResultMusic extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Result Details',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             // Use ListView.builder for scrollable cards
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 1, // Change this to the number of cards you want
//                 itemBuilder: (context, index) {
//                   return MusicCard(
//                     music: Music(
//                       track_name: context.watch<MusicProvider>().track_name,
//                       year: context.watch<MusicProvider>().release_date,
//                       genre: context.watch<MusicProvider>().genre,
//                       lyrics: context.watch<MusicProvider>().lyric,
//                       singer: context.watch<MusicProvider>().artist_name,
//                       singerPhotoUrl:
//                       'https://m.media-amazon.com/images/I/61RhWaYBp7L._AC_SL1044_.jpg',
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
// class MusicCard extends StatelessWidget {
//   final Music music;
//
//   MusicCard({required this.music});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: MusicDetails(music: music),
//       ),
//     );
//   }
// }
//
// class MusicDetails extends StatelessWidget {
//   final Music music;
//
//   MusicDetails({required this.music});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Track Name: ${music.track_name}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 20.0,
//                 ),
//               ),
//               Text(
//                 'Singer: ${music.singer}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 20.0,
//                 ),
//               ),
//               Text(
//                 'Release Date: ${music.year}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 20.0,
//                 ),
//               ),
//               Text(
//                 'Genre: ${music.genre}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 20.0,
//                 ),
//               ),
//             ],
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
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 2),
    );
  }
}

class Music {
  final int id;
  final String artist_name;
  final String track_name;
  final String genre;
  final int release_date;

  Music({
    required this.id,
    required this.artist_name,
    required this.track_name,
    required this.genre,
    required this.release_date,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'],
      artist_name: json['artist_name'],
      track_name: json['track_name'],
      genre: json['genre'],
      release_date: json['release_date'],
    );
  }
}

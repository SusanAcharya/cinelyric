import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:cinelyric/screens/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Music {
  final String track_name;
  final String year;
  final String genre;
  final String lyrics;
  final String singer;
  final String singerPhotoUrl;

  Music(
      {required this.track_name,
        required this.year,
        required this.genre,
        required this.lyrics,
        required this.singer,
        required this.singerPhotoUrl});
}

class ResultMusic extends StatelessWidget {
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
                  return MusicCard(
                    music: Music(
                      track_name: context.watch<MusicProvider>().track_name,
                      year: context.watch<MusicProvider>().release_date,
                      genre: context.watch<MusicProvider>().genre,
                      lyrics: context.watch<MusicProvider>().lyric,
                      singer: context.watch<MusicProvider>().artist_name,
                      singerPhotoUrl:
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

class MusicCard extends StatelessWidget {
  final Music music;

  MusicCard({required this.music});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MusicDetails(music: music),
      ),
    );
  }
}

class MusicDetails extends StatelessWidget {
  final Music music;

  MusicDetails({required this.music});

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
                'Track Name: ${music.track_name}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Singer: ${music.singer}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Release Date: ${music.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Genre: ${music.genre}',
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
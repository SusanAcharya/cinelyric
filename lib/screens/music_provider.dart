
import 'package:flutter/material.dart';

class MusicProvider extends ChangeNotifier {
  String id;
  String artist_name;
  String track_name;
  String genre;
  String lyric;
  String release_date;

  MusicProvider({
    this.id = "00",
    this.artist_name = "default artist",
    this.track_name = "mehabooba",
    this.genre = "classic",
    this.lyric = "House so empty, need a centerpiece",
    this.release_date = "2023",
  });

  void changeMusicDetail({
    required String newId,
    required String newArtist,
    required String newTrack,
    required String newGenre,
    required String newLyric,
    required String newYear,
  }) async {
    id = newId;
    artist_name = newArtist;
    track_name = newTrack;
    genre = newGenre;
    lyric = newLyric;
    release_date = newYear;
    notifyListeners();
  }
}
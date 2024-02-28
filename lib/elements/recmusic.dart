class RecMusic {
  final int id;
  final String artist_name;
  final String track_name;
  final String genre;
  final int release_date;
  final String youtube_link;
  final String spotify_link;
  final String album;
  final String type;

  RecMusic(
      {required this.id,
      required this.artist_name,
      required this.track_name,
      required this.genre,
      required this.release_date,
      required this.youtube_link,
      required this.spotify_link,
      required this.album,
      required this.type,});

  factory RecMusic.fromJson(Map<String, dynamic> json) {

    return RecMusic(
      id: json['id'],
      artist_name: json['artist_name'] ?? '',
      track_name: json['track_name'] ?? '',
      genre: json['genre'] ?? '',
      release_date: json['release_date'] ?? 0,
      youtube_link: json['youtube_link'] ?? '',
      spotify_link: json['spotify_link'] ?? '',
      album: json['album'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

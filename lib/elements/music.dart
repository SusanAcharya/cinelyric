class Music {
  final int id;
  final String artist_name;
  final String track_name;
  final String genre;
  final double release_date;

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

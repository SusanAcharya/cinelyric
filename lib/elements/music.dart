class Music {
  final int id;
  final String artist_name;
  final String track_name;
  final String artist_image;
  //final List<String> genre;
  final String genre;
  final int release_date;
  final String youtube_link;
  final String spotify_link;
  final String album;
  final String type;

  Music(
      {required this.id,
      required this.artist_name,
      required this.artist_image,
      required this.track_name,
      required this.genre,
      required this.release_date,
      required this.youtube_link,
      required this.spotify_link,
      required this.album,
      required this.type,});

  factory Music.fromJson(Map<String, dynamic> json) {
    // List<String> genreList = (json['genre'] as List).cast<String>();
    // //List<String> genreList = [];

    // if (json['genre'] is List) {
    //   // Use the genre list as is
    //   genreList = (json['genre'] as List).map((e) => e.toString()).toList();
    // } else if (json['genre'] is String) {
    //   // Parse the genre string into a List<String>
    //   var rawGenreList = json['genre'].replaceAll("[", "").replaceAll("]", "");
    //   genreList = rawGenreList.split(',').map((e) => e.trim()).toList();
    // }

    return Music(
      id: json['id'],
      artist_name: json['artist_name'],
      artist_image: json['artist_image'],
      track_name: json['track_name'],
      //genre: genreList,
      genre: json['genre'],
      release_date: json['release_date'],
      youtube_link: json['youtube_link'],
      spotify_link: json['spotify_link'],
      album: json['album'],
      type: json['type'],
    );
  }
}

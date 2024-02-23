// movie.dart
class Movie {
  final int id;
  final String quote;
  final String movie;
  final String type;
  final int year;
  final String poster_link;
  final String youtube_link;
  final String genre;
  final String imdb_rating;
  final String overview;
  final String metascore;
  final String director;

  Movie({
    required this.id,
    required this.quote,
    required this.movie,
    required this.type,
    required this.year,
    required this.poster_link,
    required this.youtube_link,
    required this.genre,
    required this.imdb_rating,
    required this.overview,
    required this.metascore,
    required this.director,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      quote: json['quote'],
      movie: json['movie'],
      type: json['type'],
      year: json['year'],
      poster_link: json['poster_link'],
      youtube_link: json['youtube_link'],
      genre: json['genre'],
      imdb_rating: json['imdb_rating'],
      overview: json['overview'],
      metascore: json['metascore'],
      director: json['director'],
    );
  }
}

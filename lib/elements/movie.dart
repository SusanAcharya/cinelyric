// movie.dart
class Movie {
  final int id;
  final String quote;
  final String movie;
  final String type;
  final int year;
  final String poster_link;

  Movie({
    required this.id,
    required this.quote,
    required this.movie,
    required this.type,
    required this.year,
    required this.poster_link,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      quote: json['quote'],
      movie: json['movie'],
      type: json['type'],
      year: json['year'],
      poster_link: json['poster_link'],
    );
  }
}

import 'package:flutter/material.dart';

class MovieProvider extends ChangeNotifier {
  int id;
  String quote;
  String movie;
  String type;
  String year;

  MovieProvider({
    this.id = 00,
    this.quote = "enter a quote",
    this.movie = "default movie",
    this.type = "default type",
    this.year = "2023",
  });

  void changeMovieDetail({
    required int newId,
    required String newQuote,
    required String newMovie,
    required String newType,
    required String newYear,
  }) async {
    id = newId;
    quote = newQuote;
    movie = newMovie;
    type = newType;
    year = newYear;
    notifyListeners();
  }
}

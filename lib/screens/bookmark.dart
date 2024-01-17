import 'package:flutter/material.dart';
import '../elements/movie.dart';
import 'movie_info.dart';

class BookmarkPage extends StatelessWidget {
  final List<Movie>
      bookmarkedMovies; // Assuming you have a list of bookmarked movies

  BookmarkPage({required this.bookmarkedMovies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Movies'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedMovies.length,
        itemBuilder: (context, index) {
          Movie movie = bookmarkedMovies[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieInfo(movie: movie),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movie Name: ${movie.movie}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Release Date: ${movie.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Type: ${movie.type}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Rating: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 50,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[600],
                          ),
                          child: Center(
                            child: Text(
                              '7.5', // Dummy rating value
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Image.network(
                      movie.poster_link,
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

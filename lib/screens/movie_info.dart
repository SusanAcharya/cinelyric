// import 'package:cinelyric/elements/appbar.dart';
// import 'package:cinelyric/elements/bottombar.dart';
// import 'package:cinelyric/elements/movie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'movie_result_display.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MovieInfo extends StatefulWidget {
//   final Movie movie;

//   MovieInfo({required this.movie});

//   @override
//   State<MovieInfo> createState() => _MovieInfoState();
// }

// class _MovieInfoState extends State<MovieInfo> {
//   bool _showVideoPlayer = false;
//   late YoutubePlayerController _youtubeController;
//   bool _isBookmarkClicked = false;

//   @override
//   void initState() {
//     super.initState();
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: 'dQw4w9WgXcQ', // Dummy video ID
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//       ),
//     )..addListener(_onYoutubePlayerChange);

//     _loadBookmarkState();
//   }

//   void _onYoutubePlayerChange() {
//     if (_youtubeController.value.isFullScreen) {
//       SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     } else {
//       SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     }
//   }

//   void _loadBookmarkState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool bookmarked = prefs.getBool('bookmark_${widget.movie.id}') ?? false;
//     setState(() {
//       _isBookmarkClicked = bookmarked;
//     });
//   }

//   void _saveBookmarkState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('bookmark_${widget.movie.id}', _isBookmarkClicked);
//   }

//   @override
//   void dispose() {
//     _youtubeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Movie Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 30,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Movie Name: ${widget.movie.movie}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0,
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Release Date: ${widget.movie.year}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14.0,
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Type: ${widget.movie.type}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14.0,
//                             ),
//                           ),
//                           SizedBox(height: 30),
//                           Row(
//                             children: [
//                               Text(
//                                 'Rating: ',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18.0,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Container(
//                                 width: 50,
//                                 height: 90,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.grey[600],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     '7.5', //dummy rating value ho
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                   width:
//                                       10), // Add space between rating and bookmark
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _isBookmarkClicked = !_isBookmarkClicked;
//                                     _saveBookmarkState();
//                                   });
//                                 },
//                                 child: Icon(
//                                   _isBookmarkClicked
//                                       ? Icons.bookmark
//                                       : Icons.bookmark_border,
//                                   color: Colors.white,
//                                   size: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Image.network(
//                     //   widget.movie.poster_link,
//                     //   width: 150,
//                     //   height: 200,
//                     //   fit: BoxFit.cover,
//                     // ),
//                     Image.network(
//                       widget.movie.poster_link,
//                       width: 150,
//                       height: 200,
//                       fit: BoxFit.cover,
//                       errorBuilder: (BuildContext context, Object error,
//                           StackTrace? stackTrace) {
//                         return FadeInImage.assetNetwork(
//                           placeholder:
//                               'assets/placeholder/Film-icon.png', // Placeholder image
//                           image: widget.movie.poster_link,
//                           width: 150,
//                           height: 200,
//                           fit: BoxFit.cover,
//                           imageErrorBuilder: (context, error, stackTrace) {
//                             return Image.asset(
//                               'assets/placeholder/Film-icon.png', // Error placeholder image
//                               width: 150,
//                               height: 150,
//                               fit: BoxFit.cover,
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               _showVideoPlayer
//                   ? SingleChildScrollView(
//                       child: Expanded(
//                         child: Center(
//                           child: Column(
//                             children: [
//                               YoutubePlayer(
//                                 controller: _youtubeController,
//                                 showVideoProgressIndicator: true,
//                                 onReady: () {
// //video player ready huda k garne. for now, nothing
//                                 },
//                               ),
//                               SizedBox(height: 20),
//                               IconButton(
//                                 icon: Icon(Icons.close),
//                                 onPressed: () {
//                                   setState(() {
//                                     _showVideoPlayer = false;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _showVideoPlayer = true;
//                         });
//                       },
//                       child: Center(
//                         child: Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.redAccent,
//                           ),
//                           child: Icon(
//                             Icons.play_arrow,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 3),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinelyric/elements/movie.dart';
import 'package:cinelyric/elements/bottombar.dart';

class MovieInfo extends StatefulWidget {
  final Movie movie;

  MovieInfo({required this.movie});

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  bool _showVideoPlayer = false;
  late YoutubePlayerController _youtubeController;
  bool _isBookmarkClicked = false;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: _parseYoutubeVideoId(widget.movie.youtube_link),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    )..addListener(_onYoutubePlayerChange);

    _loadBookmarkState();
  }

  String _parseYoutubeVideoId(String youtubeUrl) {
    RegExp regExp = RegExp(
        r'(?<=watch\?v=|/videos/|embed/|youtu.be/|/v/|/e/|\?v=|&v=|%2Fvideos%2F|embed%\2F|youtu.be%\2F|%2Fv%2F|\?v=|%26v%3D|^youtu\.be/)([^&?/"]+)');
    Match? match = regExp.firstMatch(youtubeUrl);
    return match?.group(0) ?? '';
  }

  void _onYoutubePlayerChange() {
    if (_youtubeController.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  void _loadBookmarkState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool bookmarked = prefs.getBool('bookmark_${widget.movie.id}') ?? false;
    setState(() {
      _isBookmarkClicked = bookmarked;
    });
  }

  void _saveBookmarkState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('bookmark_${widget.movie.id}', _isBookmarkClicked);
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.movie.movie,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Release Date: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '${widget.movie.year}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.movie.director != ''
                                ? 'Director: '
                                : 'Director: N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            widget.movie.director != ''
                                ? widget.movie.director
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.movie.genre != '' ? 'Genre: ' : 'Genre: N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            widget.movie.genre != ''
                                ? widget.movie.genre
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.movie.metascore != ''
                                ? 'MetaScore: '
                                : 'MetaScore: N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            widget.movie.metascore != ''
                                ? widget.movie.metascore
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Type: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            widget.movie.type,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              const Text(
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
                                    widget.movie.imdb_rating != ''
                                        ? widget.movie
                                            .imdb_rating // Actual rating value
                                        : 'N/A',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isBookmarkClicked = !_isBookmarkClicked;
                                    _saveBookmarkState();
                                  });
                                },
                                child: Icon(
                                  _isBookmarkClicked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Image.network(
                    //   widget.movie.poster_link,
                    //   width: 150,
                    //   height: 200,
                    //   fit: BoxFit.cover,
                    // ),
                    Image.network(
                      widget.movie.poster_link,
                      width: 150,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return FadeInImage.assetNetwork(
                          placeholder:
                              'assets/placeholder/Film-icon.png', // Placeholder image
                          image: widget.movie.poster_link,
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/placeholder/Film-icon.png', // Error placeholder image
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Movie Trailer:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              _showVideoPlayer
                  ? SingleChildScrollView(
                      child: Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              YoutubePlayer(
                                controller: _youtubeController,
                                showVideoProgressIndicator: true,
                                onReady: () {
                                  // video player ready huda k garne. for now, nothing
                                },
                              ),
                              const SizedBox(height: 20),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _showVideoPlayer = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _showVideoPlayer = true;
                        });
                      },
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
                color: Colors.white60,
              ),
              // for the recommendation of other similar movies
              const SizedBox(height: 10),
              Text(
                'The viewers of ${widget.movie.movie} also watch these movies:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              RelatedMoviesList(
                posterLink: widget.movie.poster_link,
                movieName: widget.movie.movie,
                movieType: widget.movie.type,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 1),
    );
  }
}

class RelatedMoviesList extends StatelessWidget {
  final String posterLink;
  final String movieName;
  final String movieType;

  RelatedMoviesList({
    required this.posterLink,
    required this.movieName,
    required this.movieType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of related movies to display
        itemBuilder: (context, index) {
          // For now, display the same movie as related movies
          return Container(
            margin: const EdgeInsets.only(right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    posterLink.isNotEmpty
                        ? posterLink
                        : 'https://example.com/placeholder-image.jpg',
                    width: 120,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movieName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    movieType,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cinelyric/elements/movie.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class MovieInfo extends StatefulWidget {
//   final Movie movie;

//   MovieInfo({required this.movie});

//   @override
//   State<MovieInfo> createState() => _MovieInfoState();
// }

// class _MovieInfoState extends State<MovieInfo> {
//   bool _showVideoPlayer = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Movie Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Movie Name: ${widget.movie.movie}',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16.0)),
//                       Text('Type: ${widget.movie.type}',
//                           style: TextStyle(
//                               fontWeight: FontWeight.normal, fontSize: 14.0)),
//                       Text('Release Date: ${widget.movie.year}',
//                           style: TextStyle(
//                               fontWeight: FontWeight.normal, fontSize: 14.0)),
//                       Text('Movie Quote: ${widget.movie.quote}',
//                           style: TextStyle(
//                               fontWeight: FontWeight.normal, fontSize: 14.0)),
//                       // Add more details as needed
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Image.network(
//                   widget.movie.poster_link,
//                   width: 80,
//                   height: 150,
//                   fit: BoxFit.cover,
//                 ),
//               ],
//             ),
//             Divider(),
//             SizedBox(height: 10),
//             _showVideoPlayer
//                 ? Expanded(
//                     child: Center(
//                       child: Column(
//                         children: [
//                           YoutubePlayer(
//                             controller: YoutubePlayerController(
//                               initialVideoId: 'dQw4w9WgXcQ', // Dummy video ID
//                               flags: YoutubePlayerFlags(autoPlay: true),
//                             ),
//                             showVideoProgressIndicator: true,
//                             onReady: () {
//                               // Do something when the video is ready
//                             },
//                           ),
//                           SizedBox(height: 20),
//                           IconButton(
//                             icon: Icon(Icons.close),
//                             onPressed: () {
//                               setState(() {
//                                 _showVideoPlayer = false;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _showVideoPlayer = true;
//                       });
//                     },
//                     child: Center(
//                       child: Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.redAccent,
//                         ),
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:cinelyric/elements/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'result_display_page.dart';

class MovieInfo extends StatefulWidget {
  final Movie movie;

  MovieInfo({required this.movie});

  @override
  _MovieInfoState createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  bool _showVideoPlayer = false;

  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ', // Dummy video ID
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    )..addListener(_onYoutubePlayerChange);
  }

  void _onYoutubePlayerChange() {
    if (_youtubeController.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
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
        title: Text('Movie Details'),
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quote: ${widget.movie.quote}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Movie Name: ${widget.movie.movie}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Release Date: ${widget.movie.year}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Type: ${widget.movie.type}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.network(
                      widget.movie.poster_link,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
                                  // Do something when the video is ready
                                },
                              ),
                              SizedBox(height: 20),
                              IconButton(
                                icon: Icon(Icons.close),
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 1),
    );
  }
}

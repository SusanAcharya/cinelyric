
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinelyric/elements/movie.dart';
import 'package:cinelyric/elements/recmovie.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cinelyric/screens/recmovie_detail.dart';

class MovieInfo extends StatefulWidget {
  final Movie movie;

  MovieInfo({required this.movie});

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  bool _showVideoPlayer = false;
  late YoutubePlayerController _youtubeController;
  //bool _isBookmarkClicked = false;
  String token="";
  String type = "";
  int id = 0;
  String genre = "";
  List<RecMovie> recmovies = [];

  @override
  void initState() {
    super.initState();
    genre = widget.movie.genre;
    id= widget.movie.id;
    //getDataFromSharedPreferences();
    getDataFromSharedPreferences().then((_) {
      return recMovies();
    });
    _youtubeController = YoutubePlayerController(
      initialVideoId: _parseYoutubeVideoId(widget.movie.youtube_link),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    )..addListener(_onYoutubePlayerChange);

    //_loadBookmarkState();
  }
//for parsing the url
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

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();//getting token
    String? stringValue = prefs.getString('token');
    token = stringValue!;
  }

  //for adding movie in bookmark
    Future<void> addItem() async {
    id = widget.movie.id;
    type = widget.movie.type;
    String apiUrl = 'http://10.0.2.2:8000/bookmark/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, dynamic> requestBody = {
      'id': id,
      'type': type,
    };
    String jsonBody = jsonEncode(requestBody);
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );
      if (response.statusCode == 200) {
      Map<String,dynamic> responseData = jsonDecode(response.body);
      //if (responseData.isNotEmpty && responseData[0]['message'] != null) {
        // String message = responseData[0]['message'];
        // print('Message: $message');
        if (responseData.containsKey('message')) {
        String message = responseData['message'];
        print('Message: $message');
        //return message;
        showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert:'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      }
    }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

//for retriving recommended movies
  Future<void> recMovies() async {
    // String apiUrl = 'https://3140-2400-1a00-b040-1115-2d7f-ac13-bf4c-a684.ngrok-free.app/movie/';
    String apiUrl = 'http://10.0.2.2:8000/api/recommend/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, dynamic> requestBody = {
      'id': id,
      'genre': genre,
    };
    String jsonBody = jsonEncode(requestBody);
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedData = jsonDecode(response.body);

        //recmovies = decodedData.map((data) => RecMovie.fromJson(data)).toList();
        setState(() {
        recmovies = decodedData.map((data) => RecMovie.fromJson(data)).toList();
        });
        print('Movies: $recmovies');
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jasonBody = jsonDecode(response.body);
        String message = jasonBody['message'];
        print(message);
      }
    } catch (error) {
      print('Error: $error');
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
                                  addItem();
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
              RelatedMoviesList(recommendedMovies: recmovies),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 1),
    );
  }
}


class RelatedMoviesList extends StatelessWidget {
  final List<RecMovie> recommendedMovies;

  RelatedMoviesList({required this.recommendedMovies});

  @override
  Widget build(BuildContext context) {
    return recommendedMovies.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedMovies.length,
              itemBuilder: (context, index) {
                RecMovie movie = recommendedMovies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecMovieInfo(movie: movie),
                      ),
                    );
                  },
                  child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: AspectRatio(
                          aspectRatio: 2 / 3, // Aspect ratio of the poster
                          child: Image.network(
                            movie.poster_link,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder/Film-icon.png',
                                image: movie.poster_link,
                                width: 50,
                                height: 60,
                                //fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/placeholder/Film-icon.png',
                                    width: 50,
                                    height: 60,
                                    //fit: BoxFit.cover,
                                  );
                                },
                              );
                            },
                          ),
                          
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 120,
                        child: Text(
                          movie.movie,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        movie.year.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ));
              },
            ),
          );
  }
}




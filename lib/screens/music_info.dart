
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../elements/music.dart';
import '../elements/recmusic.dart';
import '../elements/bottombar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cinelyric/screens/recmusic_detail.dart';

class MusicInfo extends StatefulWidget {
  final Music music;

  MusicInfo({required this.music});

  @override
  State<MusicInfo> createState() => _MusicInfoState();
}

class _MusicInfoState extends State<MusicInfo> {
  bool _showVideoPlayer = false;
  late YoutubePlayerController _youtubeController;
  //bool _isBookmarkClicked = false;
  String token = "";
  int id = 0;
  int bid = 0;
  String genre= "";
  String type = "";
  List<RecMusic> recmusic = [];

  @override
  void initState() {
    super.initState();
    genre = widget.music.genre;
    id= widget.music.id;
    //getDataFromSharedPreferences();
    getDataFromSharedPreferences().then((_) {
      return recMusic();
    });
    _youtubeController = YoutubePlayerController(
      initialVideoId: _parseYoutubeVideoId(widget.music.youtube_link),
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    )..addListener(_onYoutubePlayerChange);

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

 
  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();//getting token
    String? stringValue = prefs.getString('token');
    token = stringValue!;
  }

//adding music to bookmark
  Future<void> addItem() async {
    id = widget.music.id;
    type = widget.music.type;
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
      // if (responseData.isNotEmpty && responseData[0]['message'] != null) {
      //   String message = responseData[0]['message'];
      //   print('Message: $message');
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


Future<void> recMusic() async {
    // String apiUrl = 'https://3140-2400-1a00-b040-1115-2d7f-ac13-bf4c-a684.ngrok-free.app/movie/';
    String apiUrl = 'http://10.0.2.2:8000/musicRecommend/';
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
        recmusic = decodedData.map((data) => RecMusic.fromJson(data)).toList();
        });
        print('Movies: $recmusic');
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
        title: Text('Music Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
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
                            'Song Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '${widget.music.track_name}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Artist: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '${widget.music.artist_name}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Genre: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '${widget.music.genre}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Album: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '${widget.music.album}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Year: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            widget.music.release_date != ''
                                ? '${widget.music.release_date}'
                                : 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //id = widget.music.id;
                                  //type = widget.music.type;
                                  addItem();
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () async {
                                  Uri spotifyUri =
                                      Uri.parse(widget.music.spotify_link);

                                  if (await launcher
                                      .canLaunchUrl(spotifyUri)) {
                                    await launcher.launchUrl(spotifyUri);
                                  } else {
                                    print(
                                        'Could not launch ${widget.music.spotify_link}');
                                  }
                                },
                                child: Image.asset(
                                  'assets/spotify_icon.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),//displaying image
                    Image.network(
                      widget.music.artist_image.isNotEmpty ? widget.music.artist_image : 'assets/bgimagee.png',
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return FadeInImage.assetNetwork(
                          placeholder: 'assets/bgimagee.png',
                          image: widget.music.artist_image.isNotEmpty ? widget.music.artist_image : 'assets/bgimagee.png',
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/bgimagee.png',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Music Video:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
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
                                onReady: () {},
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
              SizedBox(height: 10),
              Divider(
                thickness: 2,
                color: Colors.white60,
              ),
              SizedBox(height: 10),
              Text(
                'The viewers of ${widget.music.track_name} also listen to these songs:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              RelatedMusicList(recommendedMusic: recmusic),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyAppBottomBar(currentPageIndex: 2),
    );
  }
}


class RelatedMusicList extends StatelessWidget {
  final List<RecMusic> recommendedMusic;

  RelatedMusicList({required this.recommendedMusic});

  @override
  Widget build(BuildContext context) {
    return recommendedMusic.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedMusic.length,
              itemBuilder: (context, index) {
                RecMusic music = recommendedMusic[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecMusicInfo(recmusic: music),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: AspectRatio(
                                aspectRatio: 2 / 3, // Aspect ratio of the poster
                              child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder/music-icon.jpeg',
                              image: music.artist_image,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/placeholder/music-icon.jpeg',
                                  width: 150,
                                  height: 150,
                                  //fit: BoxFit.cover,
                                );
                              },
                            ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 120,
                              child: Flexible(
                                child: Text(
                                  music.track_name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Flexible(
                                child: Text(
                                  music.artist_name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../elements/recmusic.dart';
import '../elements/bottombar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecMusicInfo extends StatefulWidget {
  final RecMusic recmusic;

  RecMusicInfo({required this.recmusic});

  @override
  State<RecMusicInfo> createState() => _MusicInfoState();
}

class _MusicInfoState extends State<RecMusicInfo> {
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
    genre = widget.recmusic.genre;
    id= widget.recmusic.id;
    getDataFromSharedPreferences();
    _youtubeController = YoutubePlayerController(
      initialVideoId: _parseYoutubeVideoId(widget.recmusic.youtube_link),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    token = stringValue!;
  }

  Future<void> addItem() async {
    id = widget.recmusic.id;
    type = widget.recmusic.type;
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
                            '${widget.recmusic.track_name}',
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
                            '${widget.recmusic.artist_name}',
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
                            '${widget.recmusic.genre}',
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
                            '${widget.recmusic.album}',
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
                            widget.recmusic.release_date != ''
                                ? '${widget.recmusic.release_date}'
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
                                      Uri.parse(widget.recmusic.spotify_link);

                                  if (await launcher
                                      .canLaunchUrl(spotifyUri)) {
                                    await launcher.launchUrl(spotifyUri);
                                  } else {
                                    print(
                                        'Could not launch ${widget.recmusic.spotify_link}');
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
                    SizedBox(width: 16),
                    Image.network(
                      widget.recmusic.artist_image.isNotEmpty ? widget.recmusic.artist_image : 'assets/bgimagee.png',
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return FadeInImage.assetNetwork(
                          placeholder: 'assets/bgimagee.png',
                          image: widget.recmusic.artist_image.isNotEmpty ? widget.recmusic.artist_image : 'assets/bgimagee.png',
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyAppBottomBar(currentPageIndex: 2),
    );
  }
}


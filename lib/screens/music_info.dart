import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../elements/music.dart';
import 'music_result_display.dart';

class MusicInfo extends StatefulWidget {
  final Music music;

  MusicInfo({required this.music});

  @override
  State<MusicInfo> createState() => _MusicInfoState();
}

class _MusicInfoState extends State<MusicInfo> {
  bool _showVideoPlayer = false;
  late YoutubePlayerController _youtubeController;
  bool _isBookmarkClicked = false;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ', // Dummy video ID for the song
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    )..addListener(_onYoutubePlayerChange);

    _loadBookmarkState();
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
    bool bookmarked = prefs.getBool('bookmark_${widget.music.id}') ?? false;
    setState(() {
      _isBookmarkClicked = bookmarked;
    });
  }

  void _saveBookmarkState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('bookmark_${widget.music.id}', _isBookmarkClicked);
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
                            'Song Name: ${widget.music.track_name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Artist: ${widget.music.artist_name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Genre: ${widget.music.genre}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
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
                    Image.network(
                      widget.music.artist_name,
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return FadeInImage.assetNetwork(
                          placeholder:
                              'assets/bgimagee.png', // Placeholder image
                          image: widget.music.artist_name,
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/bgimagee.png', // Error placeholder image
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
                                  // Video player ready action. For now, do nothing.
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
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 2),
    );
  }
}

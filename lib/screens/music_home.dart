import 'package:cinelyric/elements/bottombar.dart';
import 'package:cinelyric/screens/music_result_display.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'for_you_music.dart';

class MusicHome extends StatefulWidget {
  const MusicHome({Key? key});

  @override
  _MusicHomeState createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _controller = TextEditingController();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  //String token = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      print(_wordsSpoken);
    });
  }

  void _navigateToMusicResultPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Lottie.asset(
          'assets/resultdisplay.json',
        );
      },
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MusicResult(query: _controller.text),
        ),
      );
    });
  }

  void _navigateToForYouMusicPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForYouMusic(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, //fixing the mic button
        appBar: AppBar(
          titleSpacing: 10,
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.radio,
                  color: Theme.of(context).iconTheme.color,
                  size: 50,
                ),
                SizedBox(width: 8),
                Text(
                  'CineLyric',
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: 35,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.music_note,
                        size: 30, color: Colors.blueAccent),
                    onPressed: _navigateToForYouMusicPage,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                onSubmitted: (value) {
                  // Trigger search when user presses "Enter" on keyboard
                  setState(() {
                    _navigateToMusicResultPage();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your query',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      setState(() {
                        _navigateToMusicResultPage();
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Music Finder',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    if (_speechToText.isListening || _wordsSpoken.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              _wordsSpoken,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (!_speechToText.isListening &&
                                _wordsSpoken.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  // getDataFromSharedPreferences().then((_) {
                                  //   getMusic();
                                  // });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MusicResult(query: _wordsSpoken)),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'See Results',
                                      style: TextStyle(
                                        color: Color.fromRGBO(60, 104, 177, 1),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Color.fromRGBO(60, 104, 177, 1),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed:
              _speechToText.isListening ? _stopListening : _startListening,
          tooltip: 'Listen',
          child: Icon(
            _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            size: 30,
            color: Colors.redAccent,
          ),
        ),
        bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 2),
      ),
    );
  }
}

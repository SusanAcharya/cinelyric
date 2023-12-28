import 'dart:convert';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:cinelyric/screens/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:cinelyric/screens/result_display_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'search_result_query.dart';

class MovieHome extends StatefulWidget {
  const MovieHome({Key? key});

  @override
  _MovieHomeState createState() => _MovieHomeState();
}

class _MovieHomeState extends State<MovieHome> {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _controller = TextEditingController();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  String token = "";

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
      //getDataFromSharedPreferences();
    });
  }

  Future<void> getDataFromSharedPreferences() async {
    // Get an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    token = stringValue!;
    print('String value: $token');
  }

  Future getMovie() async {
    //getDataFromSharedPreferences();
    String apiUrl = 'http://10.0.2.2:8000/movie/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json', // Specify content type as JSON
    };
    Map<String, dynamic> requestBody = {
      'quote': _wordsSpoken,
    };
    String jsonBody = jsonEncode(requestBody);
    try {
      // Send the POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Request was successful
        print('Response: ${response.body}');
        Map<String, dynamic> decodedData = jsonDecode(response.body);
        int id = decodedData['id'];
        String quote = decodedData['quote'];
        String movie = decodedData['movie'];
        String type = decodedData['type'];
        String year = decodedData['year'];

        print('ID: $id');
        print('Quote: $quote');
        print('Movie: $movie');
        print('Type: $type');
        print('Year: $year');

        context.read<MovieProvider>().changeMovieDetail(
            newId: id,
            newQuote: quote,
            newMovie: movie,
            newType: type,
            newYear: year);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultHome()),
        );
      } else {
        // Request failed
        print('Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jasonBody = jsonDecode(response.body);
        String message = jasonBody['message'];
        print(message);
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MyAppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter your query',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // setvalue(){
                      //   _wordsSpoken = _controller.text;
                      //   getMovie();
                      // };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchQueryResult(query: _controller.text),
                        ),
                      );
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
                      'Movie Finder',
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
                                  getDataFromSharedPreferences().then((_) {
                                    getMovie();
                                  });
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => ResultHome()),
                                  // );
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
          clipBehavior: Clip.hardEdge,
          onPressed:
              _speechToText.isListening ? _stopListening : _startListening,
          tooltip: 'Listen',
          child: Icon(
            _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            size: 30,
            color: Colors.redAccent,
          ),
        ),
        bottomNavigationBar: const MyAppBottomBar(),
      ),
    );
  }
}

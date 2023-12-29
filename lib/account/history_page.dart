// history_page.dart
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:cinelyric/elements/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../elements/bottombar.dart';
import '../screens/movie_provider.dart';
import '../screens/result_display_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String token = "";
  List<Map<String, dynamic>> searchHistory =
      []; // List to store search history data
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences().then((_) {
      fetchData();
    });
  }

  Future<void> getDataFromSharedPreferences() async {
    // Get an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    token = stringValue!;
    //print('String value: $token');
  }

  Future<void> fetchData() async {
    //getDataFromSharedPreferences();
    print(token);
    String apiUrl = 'http://10.0.2.2:8000/history/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json', // Specify content type as JSON
      'Accept': 'application/json',
    };

    try {
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print(response.body);
        //final temp= response.body;
        // If the server returns a 200 OK response, parse the JSON
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          searchHistory = data.cast<Map<String, dynamic>>();
        });
        // } else {
        //   // If the server did not return a 200 OK response,
        //   // throw an exception.
        //   throw Exception('Failed to load search history');
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
    }
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
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Your History',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: searchHistory.length, //search history length
                itemBuilder: (context, index) {
                  final historyItem = searchHistory.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text('Query: ${historyItem['user_query']}'),
                        subtitle:
                            Text('Search Type: ${historyItem['search_type']}'),
                        onTap: () {
                          _wordsSpoken = historyItem['user_query'];
                          getMovie();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyAppBottomBar(),
    );
  }
}

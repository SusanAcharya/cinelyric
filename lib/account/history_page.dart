
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinelyric/elements/appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../elements/bottombar.dart';
import '../screens/music_result_display.dart';
import '../screens/movie_result_display.dart';

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
  String type = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
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
    // String apiUrl = 'https://3140-2400-1a00-b040-1115-2d7f-ac13-bf4c-a684.ngrok-free.app/history/';
    //String apiUrl = 'http://10.0.2.2:8000/history/';
    String apiUrl = 'http://65.2.9.109:8000/history/';
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
              child: searchHistory.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: searchHistory.length,
                      itemBuilder: (context, index) {
                        final historyItem = searchHistory.toList()[index];
                        // Set different colors based on search type
                        Color cardColor = historyItem['search_type'] == 'movie'
                            ? Color.fromARGB(255, 33, 77, 35)
                            : const Color.fromARGB(255, 49, 66, 75);

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                              color: cardColor,
                            ),
                            child: ListTile(
                              title:
                                  Text('Query: ${historyItem['user_query']}'),
                              subtitle: Text(
                                  'Search Type: ${historyItem['search_type']}'),
                              onTap: () {
                                _wordsSpoken = historyItem['user_query'];
                                type = historyItem['search_type'];
                                if (type == 'movie') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MovieResult(query: _wordsSpoken)),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MusicResult(query: _wordsSpoken)),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyAppBottomBar(currentPageIndex: 3),
    );
  }
}



import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/movie_provider.dart';
import '../screens/result_display_page.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({Key? key}) : super(key: key);

  @override
  _UserHistoryState createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  final String userEmail = 'user@example.com';
  bool _isDarkMode = false;
  String token = "";
  List<Map<String, dynamic>> searchHistory = []; // List to store search history data
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    // Fetch data from Django REST API
    // getDataFromSharedPreferences();
    // fetchData();
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

  Future<void> fetchData() async{
    //getDataFromSharedPreferences();
    print(token);
    String apiUrl = 'http://10.0.2.2:8000/history/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',// Specify content type as JSON
      'Accept': 'application/json',
    };

  try{
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

    // try {
    //   Response response = await post(Uri.parse('http://10.0.2.2:8000/movie/'),
    //       headers: {'Authorization': 'Token $token'},
    //       body: {'quote': _wordsSpoken});
    //   print(response.body);
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.email),
              title: Text(userEmail),
            ),
          ),
          Divider(), // Add this line
          const SizedBox(height: 20),

//           ListTile(
//   title: Text(
//     themeProvider.getDarkMode() ? 'Dark Mode' : 'Light Mode',
//     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//   ),
//   trailing: Switch(
//     value: themeProvider.getDarkMode(),
//     onChanged: (value) {
//       themeProvider.toggleTheme();
//     },
//   ),
// ),
          ListTile(
            title: Text(
              _isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  // Add your theme switching logic here
                });
              },
            ),
          ),
          Divider(), // Add this line
          const SizedBox(height: 10),
          const Text(
            'Your History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchHistory.length, //search history length
              itemBuilder: (context, index) {
                final historyItem = searchHistory[index];
                return ListTile(
                  title: Text('Query: ${historyItem['user_query']}'),
                  subtitle: Text('Search Type: ${historyItem['search_type']}'),
                  onTap: () {
                      _wordsSpoken= historyItem['user_query'];
                      getMovie();
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyAppBottomBar(),
    );
  }
}
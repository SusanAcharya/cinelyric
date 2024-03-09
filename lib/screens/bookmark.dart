import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinelyric/elements/appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../elements/bottombar.dart';

class BookmarkPage extends StatefulWidget{
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>{
   String token = "";
  List<Map<String, dynamic>> Bookmark =
      []; // List to store search history data
  int id = 0;

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
    // String apiUrl = 'https://3140-2400-1a00-b040-1115-2d7f-ac13-bf4c-a684.ngrok-free.app/history/';
    //String apiUrl = 'http://10.0.2.2:8000/bookmark/';
    String apiUrl = 'http://65.2.9.109:8000/bookmark/';
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
        // If the server returns a 200 OK response, parse the JSON
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          Bookmark = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
    }
  }

  Future<void> deleteItem() async {
  print(token);
  // String apiUrl = 'https://3140-2400-1a00-b040-1115-2d7f-ac13-bf4c-a684.ngrok-free.app/history/';
  //String apiUrl = 'http://10.0.2.2:8000/bookmark/';
  String apiUrl = 'http://65.2.9.109:8000/bookmark/';
  Map<String, String> headers = {
    'Authorization': 'Token $token',
    'Content-Type': 'application/json', // Specify content type as JSON
    'Accept': 'application/json',
  };
  Map<String, dynamic> requestBody = {
    'id': id,
  };
  String jsonBody = jsonEncode(requestBody);
  try {
    http.Response response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      print(response.body);
      fetchData(); // Refresh the list of bookmarks
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Api response: Item removed from bookmark'),
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
  } catch (error) {
    // Handle any exceptions 
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
                'Your Bookmarks',
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
                reverse: true,
                itemCount: Bookmark.length, //search history length
                itemBuilder: (context, index) {
                  final historyItem = Bookmark.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text('Title: ${historyItem['title']}'),
                        subtitle:
                            Text('Type: ${historyItem['type']}'),
                        trailing: IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              id = historyItem['id'];
                              deleteItem();
                            },
                        ),    
                        onTap: () {
                         
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
      bottomNavigationBar: MyAppBottomBar(currentPageIndex: 3),
    );
  }

}
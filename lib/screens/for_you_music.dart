import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../elements/appbar.dart';

class ForYouMusic extends StatefulWidget {
  @override
  _ForYouMusicState createState() => _ForYouMusicState();
}

class _ForYouMusicState extends State<ForYouMusic> {
  List<CarouselItem> carouselItems = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    //fetchData();
    getDataFromSharedPreferences().then((_) {
      return fetchData();
    });
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    token = stringValue!;
    print('String value: $token');
  }

  Future<void> fetchData() async {
    // String apiUrl =
    //     'https://8cd5-2400-1a00-b040-5496-7491-c660-170c-1ab5.ngrok-fre/movie/';
    //String apiUrl = 'http://10.0.2.2:8000/api/bookmarkRecommend/';
    String apiUrl = 'http://65.2.9.109:8000/api/bookmarkRecommend/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> requestBody = {
      'type': 'music',
    };
    String jsonBody = jsonEncode(requestBody);
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          carouselItems = responseData.map((data) => CarouselItem(
            imageUrl: data['artist_image'],
            title: data['track_name'],
            description: data['artist_name'],
          )).toList();
        });
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
        Map<String, dynamic> jasonBody = jsonDecode(response.body);
        String message = jasonBody['message'];
        print(message);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('No bookmarks: $message'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Musics For you:",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                SizedBox(width: 8),
                Material(
                  child: Tooltip(
                    message:
                        "We took a little sneak peek on the music you bookmarked. And we thought these songs/artists might fit your taste.",
                    child: Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: carouselItems.isEmpty
                ? Center(child: CircularProgressIndicator())
                :CarouselSlider.builder(
              itemCount: carouselItems.length,
              options: CarouselOptions(
                height: 600.0, // Adjust the height as needed
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              itemBuilder: (context, index, realIndex) {
                return _buildCarouselItem(carouselItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(CarouselItem item) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage.assetNetwork(
                                placeholder:
                                    'assets/placeholder/music-icon.jpeg',
                                image: item.imageUrl.isNotEmpty
                                    ? item.imageUrl
                                    : 'assets/placeholder/music-icon.jpeg',
                                width: double.infinity,
                                height: 300.0,
                                fit: BoxFit.fill,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/placeholder/music-icon.jpeg',
                                    width: double.infinity,
                                    height: 300.0,
                                  );
                                },
                              ),
          ),
          const SizedBox(height: 16.0),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            item.description,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class CarouselItem {
  final String imageUrl;
  final String title;
  final String description;

  CarouselItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

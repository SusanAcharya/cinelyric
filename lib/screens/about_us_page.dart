import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('About CineLyric',
                  'The project is named "CineLyric". It was developed as part of academic project for the final year\'s project for the Bsc.CSIT course. CineLyric is a mobile application developed with Flutter that implements the speech-to-text technology which takes user speech as input and converts it to text and displays it back and then navigates the user to view the results of their input query. The app has two categories: movies and music. The movie category allows user to search for iconic movie lines while the Music category allows the user to search for popular music lyrics.'),
              _buildDivider(),
              _buildSection('How it Works',
                  'CineLyric allows users to input movie dialogues or music lyrics as speech input and displays the spoken words on the screen. It then shows a list of movies or music that best match the user query based on popularity.'),
              _buildDivider(),
              _buildSection('Features',
                  'Users can view details of movies such as name, genre, release date, ratings, and poster. For music, details include name, genre, artist name, release date, and lyrics. Users can also watch trailers for movies or music videos for songs.'),
              _buildDivider(),
              _buildSection('Contact the Team',
                  'For any inquiries or feedback, please contact us at contact@cinelyric.com.'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyAppBottomBar(currentPageIndex: 3),
    );
  }

  Widget _buildSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 5,
      color: Colors.grey,
    );
  }
}

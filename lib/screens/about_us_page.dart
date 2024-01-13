// about_us_page.dart
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About CineLyric',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'CineLyric is a mobile app that provides users with information about movies, including reviews, ratings, and showtimes. Our goal is to make it easy for users to discover new movies and enjoy a seamless movie-watching experience.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Key Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Movie Reviews and Ratings'),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Showtimes and Ticket Booking'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User Account and History'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyAppBottomBar(currentPageIndex: 3),
    );
  }
}

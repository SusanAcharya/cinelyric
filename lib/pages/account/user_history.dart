import 'package:flutter/material.dart';

class UserHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineLyric: Music Home'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Set app bar color
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount:
                  10, // Replace with the actual length of your search history list
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Search Item $index'), // Replace with actual search history data
                  // Add any other relevant information
                  onTap: () {
                    // Handle tap on history item
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            IconButton(
              icon: Icon(Icons.movie),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/movie');
              },
            ),
            IconButton(
              icon: Icon(Icons.music_note),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/music');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/history');
              },
            ),
          ],
        ),
      ),
    );
  }
}

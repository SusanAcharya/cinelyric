import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<bool> _isOpen = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildFAQItem(0, 'How does CineLyric work?',
                  'CineLyric utilizes speech-to-text technology to convert your spoken words into text. Simply choose between the movie and music sections, provide the relevant input, and the app will display the results based on popularity.'),
              _buildFAQItem(1, 'Can I use CineLyric for any language?',
                  'Currently, CineLyric supports only English. But we are planning to expand our language support.'),
              _buildFAQItem(2, 'How accurate is the speech-to-text feature?',
                  'CineLyric employs advanced speech recognition technology for accurate transcription. However, results may vary depending on background noise and speech clarity.'),
              _buildFAQItem(
                  3,
                  'How are the movie and music results ranked on the result page?',
                  'Results are displayed based on popularity. The more popular the movie or music, the higher it appears on the result page.'),
              _buildFAQItem(
                  4,
                  'Can I get more details about a specific movie or music after selecting it from the result page?',
                  'Yes, selecting a movie or music will take you to a dedicated result page with details such as movie name, genre, release date, ratings, and posters for movies, and music name, genre, artist name, release date, and lyrics for music.'),
              _buildFAQItem(5, 'How do I bookmark my favorite movies or music?',
                  'Simply click on the bookmark icon next to the movie or music you want to save. You can view your bookmarked items anytime in the app.'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyAppBottomBar(
        currentPageIndex: 3,
      ),
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            question,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(_isOpen[index] ? Icons.remove : Icons.add),
            onPressed: () {
              setState(() {
                _isOpen[index] = !_isOpen[index];
              });
            },
          ),
        ),
        if (_isOpen[index])
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              answer,
              style: TextStyle(fontSize: 18),
            ),
          ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

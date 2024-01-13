// faq_page.dart
import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<bool> _isOpen = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildFAQItem(0, 'Question 1', 'Answer 1'),
            _buildFAQItem(1, 'Question 2', 'Answer 2'),
            _buildFAQItem(2, 'Question 3', 'Answer 3'),
            _buildFAQItem(3, 'Question 4', 'Answer 4'),
            _buildFAQItem(4, 'Question 5', 'Answer 5'),
          ],
        ),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 16),
            ),
          ),
        const Divider(),
      ],
    );
  }
}

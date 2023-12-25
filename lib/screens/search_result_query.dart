import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';

class SearchQueryResult extends StatelessWidget {
  final String query;

  SearchQueryResult({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'We found this information for your query:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  3, // replace this with the length of your search results
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Name $index'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Genre $index'),
                        Text('Release Date $index'),
                        Text('Your query: "$query"'),
                      ],
                    ),
                    onTap: () {},
                  ),
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

import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/bottombar.dart';
import 'package:flutter/material.dart';
import '../elements/facts_list.dart';

class FunFactPage extends StatefulWidget {
  const FunFactPage({super.key});

  @override
  _FunFactPageState createState() => _FunFactPageState();
}

class _FunFactPageState extends State<FunFactPage> {
  // Get the fun facts from the FunFactsList class
  List<String> funFacts = FunFactsList.facts;

  // Index to track the current fun fact
  int currentFactIndex = 0;

  // Function to update the fun fact
  void _updateFunFact() {
    setState(() {
      // Increment the index or reset to 0 if at the end of the list
      currentFactIndex = (currentFactIndex + 1) % funFacts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // Display the current fun fact
              funFacts[currentFactIndex],
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _updateFunFact,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(60, 104, 177, 1),
              ),
              child: const Text(
                'Show Another Fun Fact',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 3),
    );
  }
}

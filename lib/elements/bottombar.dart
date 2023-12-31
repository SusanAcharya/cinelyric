import 'package:flutter/material.dart';

class MyAppBottomBar extends StatelessWidget {
  const MyAppBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.movie),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/movie');
            },
          ),
          IconButton(
            icon: const Icon(Icons.music_note),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/music');
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/history');
            },
          ),
        ],
      ),
    );
  }
}

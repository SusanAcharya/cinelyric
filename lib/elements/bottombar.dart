import 'package:flutter/material.dart';

class MyAppBottomBar extends StatefulWidget {
  final int currentPageIndex;

  const MyAppBottomBar({super.key, required this.currentPageIndex});

  @override
  State<MyAppBottomBar> createState() => _MyAppBottomBarState();
}

class _MyAppBottomBarState extends State<MyAppBottomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildIconWithLabel(0, Icons.home, 'Home'),
          buildIconWithLabel(1, Icons.movie, 'Movies'),
          buildIconWithLabel(2, Icons.music_note, 'Music'),
          buildIconWithLabel(3, Icons.account_circle, 'Account'),
        ],
      ),
    );
  }

  Widget buildIconWithLabel(int index, IconData iconData, String label) {
    return InkWell(
      onTap: () {
        // Always allow navigation even if the user is on the current page
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/movie');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/music');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/account');
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: _currentIndex == index ? Colors.redAccent : Colors.yellow,
            size: _currentIndex == index ? 26.0 : 20.0,
          ),
          Text(
            label,
            style: TextStyle(
              color: _currentIndex == index ? Colors.redAccent : Colors.yellow,
              fontSize: _currentIndex == index ? 16.0 : 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

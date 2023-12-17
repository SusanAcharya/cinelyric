import 'package:cinelyric/elements/appbar.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgimageee.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}

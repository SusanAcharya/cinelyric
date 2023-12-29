// ignore_for_file: unused_import

import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/scaffold_bg.dart';
import 'package:flutter/material.dart';
import '../account/login_page.dart';
import '../elements/scaffold_bg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Container(
            child: Image.asset(
              'assets/landingimagee.png',
              width: double.infinity,
              height: 500,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Color.fromRGBO(48, 53, 147, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to login',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

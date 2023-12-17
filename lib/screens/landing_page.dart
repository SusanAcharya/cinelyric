// ignore_for_file: unused_import

import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/elements/scaffold_bg.dart';
import 'package:flutter/material.dart';
import '../account/login_page.dart';
import '../elements/scaffold_bg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Container(
            child: Image.asset(
              'assets/landingimagee.png',
              width: double.infinity,
              height: 500,
            ),
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
                backgroundColor: Color.fromRGBO(60, 104, 177, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
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

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../account/login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isScrollingDown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                'CINELYRIC',
                style: TextStyle(
                  fontSize: 60,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                child: Lottie.asset(
                  'assets/initial.json',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // Check if the user is scrolling down
                if (details.primaryDelta! > 0) {
                  setState(() {
                    _isScrollingDown = true;
                  });
                }
              },
              onVerticalDragEnd: (details) {
                // Check if the drag gesture ends and the user was scrolling down
                if (_isScrollingDown) {
                  _isScrollingDown = false;
                  // Open LoginPage with transition
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          LoginPage(),
                      transitionsBuilder:
                          (context, animation1, animation2, child) {
                        const begin = Offset(0.0, -10.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation1.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 1250),
                    ),
                  );
                }
              },
              child: Container(
                width: 100,
                height: 100,
                child: Center(
                  child: Lottie.asset(
                    'assets/arrow.json',
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

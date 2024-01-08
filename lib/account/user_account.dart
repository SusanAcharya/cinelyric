// user_account.dart
import 'package:cinelyric/elements/appbar.dart';
import 'package:flutter/material.dart';

import '../elements/bottombar.dart';
import '../screens/about_us_page.dart';
import '../screens/faq_page.dart';
import '../screens/feedback_page.dart';
import 'history_page.dart';
import 'login_page.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  final String userEmail = 'user@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(
                Icons.email,
                size: 30,
              ),
              title: Text(
                userEmail,
                style: const TextStyle(fontSize: 18),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.logout,
                  size: 25,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Your History',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryPage()),
                    );
                  },
                  child: const Icon(
                    Icons.history,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 4,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('FAQ\'s'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQPage()),
                    );
                  },
                ),
                const Divider(
                  thickness: 4,
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About us'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()),
                    );
                  },
                ),
                const Divider(
                  thickness: 4,
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Write feedback'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()),
                    );
                  },
                ),
                const Divider(
                  thickness: 4,
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
                const Divider(
                  thickness: 4,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyAppBottomBar(),
    );
  }
}

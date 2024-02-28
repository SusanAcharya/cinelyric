import 'package:cinelyric/account/history_page.dart';
import 'package:cinelyric/account/login_page.dart';
import 'package:cinelyric/elements/appbar.dart';
import 'package:cinelyric/screens/about_us_page.dart';
import 'package:cinelyric/screens/bookmark.dart';
import 'package:cinelyric/screens/faq_page.dart';
import 'package:cinelyric/screens/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../elements/bottombar.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserAccount> {
  late String userEmail;
  String token = "";
  List<Map<String, dynamic>> searchHistory = [];
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? 'user@example.com';
    });
  }

  void _saveUserEmail(String newEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', newEmail);
  }

  void _editEmail() {
    String newEmail = userEmail;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Email'),
          content: TextField(
            onChanged: (value) {
              newEmail = value;
            },
            decoration: InputDecoration(hintText: 'Enter new email'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _saveUserEmail(newEmail); // Save new email to SharedPreferences
                setState(() {
                  userEmail = newEmail;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                  Icons.edit,
                  size: 25,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  _editEmail();
                },
              ),
            ),
          ),
          const Divider(
            thickness: 4,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 25, top: 16, bottom: 16),
            child: Row(
              children: [
                const Text(
                  'Your History',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 170,
                ),
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
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 4),
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
                  leading: const Icon(Icons.bookmark_add),
                  title: const Text('Your Bookmarks'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookmarkPage()),
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
                    //Navigator.pushReplacementNamed(context, '/login');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (route) => false,
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
      bottomNavigationBar: const MyAppBottomBar(currentPageIndex: 3),
    );
  }
}

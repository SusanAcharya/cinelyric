import 'dart:convert';
import 'package:cinelyric/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../elements/appbar.dart';
import 'signup_page.dart';
import 'forgot_password.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoggingIn = false;
  bool _isPasswordVisible = false;

  void _login(String email, String password) async {
    try {
      //Response response = await post(Uri.parse('http://10.0.2.2:8000/login/'),
      Response response = await post(Uri.parse('http://65.2.9.109:8000/login/'),
          body: {'username': email, 'password': password});
      if (response.statusCode == 200) {
        print('login successful');
        print(response.body);
        final jsonResponse = json.decode(response.body);
        final String token = jsonResponse['data']['Token'];
        print(token);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString(
            'username', email); // Save user email to SharedPreferences
        await prefs.setString('userEmail', email);


        setState(() {
          _isLoggingIn = true;
        });

        Future.delayed(Duration(milliseconds: 1500), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false,
          );
        });
      } else {
        print('login failed');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('LoginError'),
              content: Text('Password or email do not match.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const MyAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoggingIn
              ? Center(
                  child: Lottie.asset(
                    'assets/loading.json',
                    fit: BoxFit.cover,
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login Page',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(60, 104, 177, 1),
                        ),
                        onPressed: () {
                          _login(
                              _emailController.text, _passwordController.text);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // SizedBox(height: 10),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ForgotPassword()),
                      //     );
                      //   },
                      //   child: Text(
                      //     'Forgot Password?',
                      //     style: TextStyle(
                      //       color: Colors.redAccent,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Sign up',
                          style: TextStyle(
                            color: Color.fromRGBO(60, 104, 177, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:way2techv1/pages/forgot_password.dart';
import 'dart:convert';
import 'home.dart';
import 'sign_up.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Check if the user is already logged in
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // Here you would typically check shared preferences or secure storage
    // to see if the user is already logged in.
    // For now, we'll assume the user is not logged in.
    setState(() {
      _isLoggedIn = false; // Update this based on actual login status
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;
    final response = await http.post(
      Uri.parse(
          'http://192.168.106.119:3000/login'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Login successful, navigate to home page
      setState(() {
        _isLoggedIn = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HomePage()), // Replace with your HomePage widget
      );
    } else {
      // Login failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Email
              const Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  bottom: 4.0,
                ),
                child: Text("Email"),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  bottom: 4.0,
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  bottom: 4.0,
                ),
                child: const Text("Password"),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  bottom: 4.0,
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Remember me and Forgot password
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    const Text("Remember me"),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        // Add forgot password logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Log In Button
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 120,
                    ),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.black26,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Or"),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.black26,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Google logic
                      },
                      icon: Image.asset(
                        "assets/images/google.png",
                        height: 25,
                      ),
                      label: const Text("Continue with Google"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // LinkedIn logic
                      },
                      icon: Image.asset(
                        'assets/images/linkedin.png',
                        height: 27,
                      ),
                      label: const Text("Continue with LinkedIn"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to RegisterPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way2techv1/pages/nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountPage extends StatefulWidget {
  final String? email;

  AccountPage({this.email});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? email; 
  String? username; 
  String? fullName; 

  @override
  void initState() {
    super.initState();
    loadEmailAndUserDetails();
  }
  Future<void> loadEmailAndUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

    if (userEmail != null) {
      try {
        Map<String, dynamic> userDetails = await retrieveUserDetails(userEmail);

        setState(() {
          email = userEmail;
          username = userDetails['username'];
          fullName = "${userDetails['firstName']} ${userDetails['lastName']}";
        });
      } catch (e) {
        setState(() {
          email = userEmail;
          username = "Unknown User";
          fullName = "Unknown User";
        });
      }
    } else {
      setState(() {
        email = null;
        username = "Unknown User";
        fullName = "Unknown User";
      });
    }
  }

  Future<Map<String, dynamic>> retrieveUserDetails(String email) async {
    final url = Uri.parse('http://localhost:3000/retrieveusername');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception("User not found");
      } else {
        throw Exception("Error retrieving user details");
      }
    } catch (e) {
      throw Exception("Failed to connect to API");
    }
  }

  Future<void> clearUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  Future<void> _logout() async {
    await clearUserEmail();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: email == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(Icons.person,
                                    size: 50, color: Colors.white),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullName ?? 'Unknown User',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      username ?? 'No username',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit profile functionality
                                },
                              ),
                            ],
                          ),
                          Divider(thickness: 1.0, color: Colors.grey.shade300),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Personal information'),
                          onTap: () {
                            // Navigate to personal information page
                          },
                        ),
                        Divider(thickness: 1.0, color: Colors.grey.shade300),
                        ListTile(
                          leading: Icon(Icons.language),
                          title: Text('Language'),
                          trailing: Text('English (US)'),
                          onTap: () {
                            // Navigate to language settings page
                          },
                        ),
                        Divider(thickness: 1.0, color: Colors.grey.shade300),
                        ListTile(
                          leading: Icon(Icons.policy),
                          title: Text('Privacy Policy'),
                          onTap: () {
                            // Navigate to privacy policy page
                          },
                        ),
                        Divider(thickness: 1.0, color: Colors.grey.shade300),
                        ListTile(
                          leading: Icon(Icons.help_center),
                          title: Text('Help center'),
                          onTap: () {
                            // Navigate to help center page
                          },
                        ),
                        Divider(thickness: 1.0, color: Colors.grey.shade300),
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Setting'),
                          onTap: () {
                            // Navigate to settings page
                          },
                        ),
                        Divider(thickness: 1.0, color: Colors.grey.shade300),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _logout,
                            child: Text(
                              'Log Out',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Navbar(
        email: email ?? '',
      ),
    );
  }
}
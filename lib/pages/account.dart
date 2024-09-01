import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way2techv1/pages/nav_bar.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = _getUserEmail().then((email) => _fetchUserData(email));
  }

  Future<String> _getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? '';
  }

  Future<Map<String, dynamic>> _fetchUserData(String email) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.80.119:3000/user/${email}'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<void> clearUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Account")),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                                    user['name'] ?? 'Unknown User',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user['email'] ?? 'No Email',
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
                          onPressed: () async {
                            await clearUserEmail();
                            // Navigate to login page or perform other logout actions
                          },
                          child: Text('Log Out'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}

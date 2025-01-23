import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way2techv1/pages/nav_bar.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatefulWidget {
  final String email;

  AccountPage({required this.email});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> clearUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  Future<void> _logout() async {
    await clearUserEmail();
    context.go('/login'); // Navigate to the login/signup screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
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
                          child:
                              Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unknown User', // Placeholder for user's name
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.email, // Display the email using widget.email
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
        email: widget.email,
      ),
    );
  }
}
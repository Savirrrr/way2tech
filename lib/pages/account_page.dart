// lib/pages/account_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:way2techv1/models/user_model.dart';
import 'package:way2techv1/service/user_service.dart';
import 'package:way2techv1/widget/logout_button.dart';
import 'package:way2techv1/widget/navbar.dart';
import 'package:way2techv1/widget/profile_card.dart';
import 'package:go_router/go_router.dart';

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
      UserModel userDetails = await retrieveUserDetails(userEmail);
      setState(() {
        email = userEmail;
        username = userDetails.username;
        fullName = "${userDetails.firstName} ${userDetails.lastName}";
      });
    } catch (e, stackTrace) {
      print("Error loading user details: $e");
      print(stackTrace);
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
                  ProfileCard(
                    fullName: fullName ?? 'Unknown User',
                    username: username ?? 'No username',
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
                        LogoutButton(onLogout: _logout),
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
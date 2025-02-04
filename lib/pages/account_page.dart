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

  const AccountPage({Key? key, this.email}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserModel? userDetails;
  bool isLoading = true;
  String? currentEmail;

  @override
  void initState() {
    super.initState();
    loadEmailAndUserDetails();
  }

  Future<void> loadEmailAndUserDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      // First try to get email from widget property
      String? userEmail = widget.email;

      // If not available, try to get from SharedPreferences
      if (userEmail == null || userEmail.isEmpty) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        userEmail = prefs.getString('userEmail');
      }

      if (userEmail != null && userEmail.isNotEmpty) {
        try {
          final details = await retrieveUserDetails(userEmail);
          setState(() {
            userDetails = details;
            currentEmail = userEmail;
            isLoading = false;
          });
        } catch (e) {
          print("Error loading user details: $e");
          setState(() {
            userDetails = UserModel(
              email: userEmail!,
              username: "Unknown User",
              firstName: "Unknown",
              lastName: "User",
            );
            currentEmail = userEmail;
            isLoading = false;
          });
        }
      } else {
        // No email found - user needs to login
        context.go('/login');
      }
    } catch (e) {
      print("Error in loadEmailAndUserDetails: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> clearUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  Future<void> _logout() async {
    try {
      await clearUserEmail();
      context.go('/login');
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (userDetails != null)
                    ProfileCard(
                      email: currentEmail!,
                      fullName: "${userDetails!.firstName} ${userDetails!.lastName}",
                      username: userDetails!.username,
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
      bottomNavigationBar: currentEmail != null
          ? Navbar(
              email: currentEmail!,
              initialIndex: 3,
            )
          : null,
    );
  }
}
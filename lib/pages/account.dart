import 'package:flutter/material.dart';
import 'package:way2techv1/pages/nav_bar.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Account")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              // color: Colors.white,
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
                                'Ayush Kumar',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '22rg110b05@anurag.edu.in',
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
                            // edit profile
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
                      // information page
                    },
                  ),
                  Divider(thickness: 1.0, color: Colors.grey.shade300),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    trailing: Text('English (US)'),
                    onTap: () {
                      // language settings
                    },
                  ),
                  Divider(thickness: 1.0, color: Colors.grey.shade300),
                  ListTile(
                    leading: Icon(Icons.policy),
                    title: Text('Privacy Policy'),
                    onTap: () {
                      // privacy policy
                    },
                  ),
                  Divider(thickness: 1.0, color: Colors.grey.shade300),
                  ListTile(
                    leading: Icon(Icons.help_center),
                    title: Text('Help center'),
                    onTap: () {
                      //  help center
                    },
                  ),
                  Divider(thickness: 1.0, color: Colors.grey.shade300),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Setting'),
                    onTap: () {
                      // settings
                    },
                  ),
                  Divider(thickness: 1.0, color: Colors.grey.shade300),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //  logout
                      },
                      child: Text('Log Out'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}

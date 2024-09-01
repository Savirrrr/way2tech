import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:way2techv1/pages/account.dart';

class Navbar extends StatelessWidget {
  final String email;

  const Navbar({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // notification logic
              },
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // menu logic
              },
            ),
            IconButton(
              icon: Icon(Icons.share, color: Colors.black),
              onPressed: () {
                // share logic
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {
                // Navigate to AccountPage and pass the email
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(email: email),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

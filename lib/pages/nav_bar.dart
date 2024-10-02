import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:way2techv1/pages/account.dart';
import 'package:way2techv1/pages/home.dart';
import 'package:way2techv1/pages/upload.dart';

class Navbar extends StatelessWidget {
  final String email;
  final VoidCallback? onHomeTapped;

  const Navbar({super.key, required this.email, this.onHomeTapped});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black),
              onPressed: () {
                if (onHomeTapped != null) {
                  onHomeTapped!(); // Just refresh the home data without navigating
                }
                // context.go('/home');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(email: email)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.explore, color: Colors.black),
              onPressed: () {
                context.go('/explore'); // Navigate to the explore page route
              },
            ),
            IconButton(
              icon: const Icon(Icons.upload, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadPage(email: email),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.business, color: Colors.black),
              onPressed: () {
                context.go('/business'); // Navigate to the business page route
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {
                // Navigate to AccountPage with email
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

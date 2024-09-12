import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:way2techv1/pages/account.dart';
import 'package:way2techv1/pages/upload.dart';

class Navbar extends StatelessWidget {
  final String email;

  const Navbar({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color:
          Colors.white, // Assuming the background is white based on the image
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black), // Home icon
              onPressed: () {
                // Home navigation logic
              },
            ),
            IconButton(
              icon: const Icon(Icons.explore,
                  color: Colors.black), // Compass/explore icon
              onPressed: () {
                // Explore navigation logic
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.upload, color: Colors.black), // Upload icon
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
              icon: Icon(Icons.business,
                  color: Colors.black), // Business/briefcase icon
              onPressed: () {
                // Business navigation logic
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black), // Person icon
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

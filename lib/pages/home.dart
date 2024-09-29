import 'package:flutter/material.dart';
import 'package:way2techv1/pages/app_bar.dart';
import 'package:way2techv1/pages/nav_bar.dart';

class HomePage extends StatelessWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Card(
        color: Colors.white,
      ),
      bottomNavigationBar: Navbar(email: email),
    );
  }
}

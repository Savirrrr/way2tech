import 'package:flutter/material.dart';
import 'package:way2techv1/pages/app_bar.dart';
import 'package:way2techv1/pages/nav_bar.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String email;
  // String caption,title,userna;
  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<void> _displayContent() async {
  try {
    final response = await http.get(Uri.parse('/*link*/'), headers: {
      'Content-Type': 'application/json',
    });
  } catch (err) {
    // print("Exception"+err);
  }
}

void _retreivemaxIndex() async {
  try {
    final response = await http.get(Uri.parse('/*link*/'), headers: {
      'Content-Type': 'application/json',
    });
  } catch (e) {}
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Card(
        color: Colors.white,
      ),
      bottomNavigationBar: Navbar(email: widget.email),
    );
  }
}

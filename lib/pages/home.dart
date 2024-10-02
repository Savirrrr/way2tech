import 'package:flutter/material.dart';
import 'package:way2techv1/pages/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class UploadData {
  final String title;
  final String caption;
  final String username;
  final String mediaUrl;

  UploadData({
    required this.title,
    required this.caption,
    required this.username,
    required this.mediaUrl,
  });

  factory UploadData.fromJson(Map<String, dynamic> json) {
    return UploadData(
      title: json['title'],
      caption: json['caption'],
      username: json['username'],
      mediaUrl: json['media'],
    );
  }
}

class RandomNumberGenerator {
  int? _maxIndex;
  Set<int> _generatedNumbers = {};

  // Function to retrieve max index from the backend
  Future<void> _retrieveMaxIndex() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.148:3000/maxIndex'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _maxIndex = int.parse(response.body);
        print("Max Index: $_maxIndex");
      } else {
        print(
            "Failed to retrieve max index. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  int? generateUniqueRandomNumber() {
    if (_maxIndex != null) {
      if (_generatedNumbers.length >= _maxIndex! + 1) {
        print("All numbers have been generated already.");
        return null;
      }

      Random random = Random();
      int randomNumber;

      do {
        randomNumber = random.nextInt(_maxIndex! + 1);
      } while (_generatedNumbers.contains(randomNumber));

      _generatedNumbers.add(randomNumber);
      return randomNumber;
    } else {
      return null;
    }
  }

  Future<int?> getMaxIndexAndGenerateRandom() async {
    await _retrieveMaxIndex();
    return generateUniqueRandomNumber();
  }
}

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UploadData? uploadedData;
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the page is first opened
  }

  // Function to fetch data from the backend and update the UI
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      RandomNumberGenerator rng = RandomNumberGenerator();
      final int? randomIndex = await rng.getMaxIndexAndGenerateRandom();

      if (randomIndex != null) {
        final response = await http.post(
          Uri.parse('http://192.168.0.148:3000/retreiveData'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({'index': randomIndex}),
        );
        print(response.body);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          print("Decode process ended");
          setState(() {
            uploadedData = UploadData.fromJson(data);
            print(uploadedData);
            isLoading = false; // Hide loading indicator
          });
        } else {
          print("Failed to retrieve data. Status code: ${response.statusCode}");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("No valid random index could be generated.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      print("Error: $err");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle pull-to-refresh
  Future<void> _refreshPage() async {
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Uploaded Data"),
      // ),
      body: RefreshIndicator(
        onRefresh: _refreshPage, // Pull-to-refresh action
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : uploadedData != null
                ? ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Title
                      Text(
                        "Title: ${uploadedData!.title}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Larger font size for title
                        ),
                      ),
                      const SizedBox(
                          height: 16), // Space between title and image

                      // Image
                      Image.network(uploadedData!.mediaUrl),
                      const SizedBox(
                          height: 8), // Space between image and username/email

                      // Username or email
                      Text(
                        uploadedData!.username,
                        style: TextStyle(
                          fontSize: 14, // Smaller font size for username/email
                          color:
                              Colors.grey[600], // Grey color for username/email
                        ),
                      ),
                      const SizedBox(
                          height:
                              16), // Space between username/email and caption

                      // Caption
                      Text(
                        "Caption: ${uploadedData!.caption}",
                        style: const TextStyle(
                          fontSize: 16, // Normal font size for caption
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text("No data retrieved yet."),
                  ),
      ),
      bottomNavigationBar: Navbar(
        email: widget.email,
        onHomeTapped: _fetchData, // Trigger data fetch when home is tapped
      ),
    );
  }
}

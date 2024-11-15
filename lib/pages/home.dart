import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:way2techv1/pages/app_bar.dart';
import 'package:way2techv1/pages/nav_bar.dart'; // For handling base64 data

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
      title: json['title'] ?? 'No Title',
      caption: json['text'] ?? 'No Caption',
      username: json['userId'] ?? 'Unknown User',
      mediaUrl: json['media'] != null ? json['media']['data'] : '',
    );
  }
}

class ReverseNumberGenerator {
  int _currentIndex;

  ReverseNumberGenerator(this._currentIndex);

  int? generatePreviousNumber() {
    if (_currentIndex >= 0) {
      return _currentIndex--;
    }
    return null;
  }
}

class FlipPageView extends StatefulWidget {
  final String email;

  const FlipPageView({super.key, required this.email});

  @override
  State<FlipPageView> createState() => _FlipPageViewState();
}

class _FlipPageViewState extends State<FlipPageView> {
  PageController _pageController = PageController();
  List<UploadData> _pagesData = [];
  bool isLoading = true;
  ReverseNumberGenerator? rng;

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Load the initial page
  }

  Future<void> _loadInitialData() async {
    await _retrieveMaxIndex();
  }

  Future<void> _retrieveMaxIndex() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.10.11.121:3000/maxIndex'),
        headers: {'Content-Type': 'application/json'},
      );

      print("Max Index Response: ${response.body}"); // Debug print

      if (response.statusCode == 200) {
        final maxIndex = int.parse(response.body);
        rng = ReverseNumberGenerator(maxIndex - 1); // Initialize with max index
        await _fetchData(); // Fetch the first set of data
      } else {
        print(
            "Failed to retrieve max index. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchData() async {
    if (rng != null) {
      final int? currentIndex = rng!.generatePreviousNumber();

      print("Current Index: $currentIndex"); // Debug print

      if (currentIndex != null) {
        final response = await http.post(
          Uri.parse('http://10.10.11.121:3000/retreiveData'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({'index': currentIndex}),
        );

        print("Fetch Data Response: ${response.body}"); // Debug print

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          setState(() {
            _pagesData.add(UploadData.fromJson(data));
            isLoading = false;
          });
        } else {
          print("Failed to retrieve data. Status code: ${response.statusCode}");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("No more pages to fetch.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pagesData.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: _pagesData.length + 1, // +1 for "caught up" page
                  itemBuilder: (context, index) {
                    if (index < _pagesData.length) {
                      return _buildFlipPage(_pagesData[index], index);
                    } else {
                      return _buildCaughtUpPage();
                    }
                  },
                  onPageChanged: (index) {
                    if (index == _pagesData.length - 1) {
                      _fetchData(); // Load next page data when scrolled to last page
                    }
                  },
                  scrollDirection: Axis.vertical, // Vertical page scrolling
                )
              : const Center(
                  child: Text("No data retrieved yet."),
                ),
      bottomNavigationBar: Navbar(email: widget.email),
    );
  }

  Widget _buildFlipPage(UploadData data, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double pagePosition = 0;
        if (_pageController.position.hasContentDimensions) {
          pagePosition = _pageController.page! - index;
        }
        double angle = pagePosition.clamp(-1, 1) * (3.14 / 2);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective effect
            ..rotateX(pagePosition.clamp(-1, 1) * (3.14 / 2)), // Flip effect
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display image
                const SizedBox(
                  height: 20,
                ),
                data.mediaUrl.isNotEmpty
                    ? Image.memory(
                        base64Decode(data.mediaUrl),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : const Text("No image available"),
                const SizedBox(height: 8),
                // Display username
                Text(
                  data.username,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                // Display title
                Text(
                  data.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                // Display caption
                Text(
                  data.caption,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCaughtUpPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "You're all caught up!",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

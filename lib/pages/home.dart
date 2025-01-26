import 'package:flutter/material.dart';
import 'package:way2techv1/models/upload_model.dart';
import 'package:way2techv1/service/api_service.dart';
import 'package:way2techv1/widget/caught_up_page.dart';
import 'package:way2techv1/widget/flip_page.dart';
import '../widget/navbar.dart';

class FlipPageView extends StatefulWidget {
  final String email;

  const FlipPageView({super.key, required this.email});

  @override
  State<FlipPageView> createState() => _FlipPageViewState();
}

class _FlipPageViewState extends State<FlipPageView> {
  final PageController _pageController = PageController();
  final ApiService _apiService = ApiService();

  List<UploadData> _pagesData = [];
  bool isLoading = true;
  ReverseNumberGenerator? rng;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final maxIndex = await _apiService.retrieveMaxIndex();
      rng = ReverseNumberGenerator(maxIndex - 1);
      await _fetchData();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchData() async {
    if (rng != null) {
      final int? currentIndex = rng!.generatePreviousNumber();

      if (currentIndex != null) {
        try {
          final data = await _apiService.fetchData(currentIndex);
          if (data != null) {
            setState(() {
              _pagesData.add(data);
              isLoading = false;
            });
          }
        } catch (e) {
          print("Error: $e");
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pagesData.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: _pagesData.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _pagesData.length) {
                      return FlipPage(data: _pagesData[index]);
                    } else {
                      return const CaughtUpPage();
                    }
                  },
                  onPageChanged: (index) {
                    if (index == _pagesData.length - 1) {
                      _fetchData();
                    }
                  },
                  scrollDirection: Axis.vertical,
                )
              : const Center(
                  child: Text("No data retrieved yet."),
                ),
      bottomNavigationBar: Navbar(email: widget.email),
    );
  }
}
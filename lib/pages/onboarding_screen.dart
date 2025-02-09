import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:way2techv1/widget/black_curve_painter.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _navigateToLoginSignup(BuildContext context) {
    context.go('/loginsignup'); // Navigate to the login/signup page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Black curved design at the top
          Align(
            alignment: Alignment.topCenter,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.55), // Adjust height
              painter: BlackCurvePainter(),
            ),
          ),
          // Main content below the curve
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Follow the latest news\ninformation every day',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Ensure text is readable on the black background
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Turn on notifications for daily updates',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Lighter grey for better contrast
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _navigateToLoginSignup(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 40), // Space below the button
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
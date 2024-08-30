import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

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
                      Text(
                        'Follow the latest news\ninformation every day',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black, // Ensure text is readable on the black background
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Turn on notifications for daily updates',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Colors.black, // Lighter grey for better contrast
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _navigateToLoginSignup(context),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 40), // Space below the button
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

class BlackCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 0); // Start from top-left
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, 0); // Curve path to top-right
    path.lineTo(size.width, 0); // Line to top-right
    path.lineTo(0, 0.6); // Line back to the start to close path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

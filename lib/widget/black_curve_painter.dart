import 'package:flutter/material.dart';

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
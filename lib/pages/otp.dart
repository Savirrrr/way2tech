import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:way2techv1/pages/confirm_password.dart';
import 'login_page.dart'; // Import the Login page

class OTPVerificationPage extends StatefulWidget {
  final String email;
  final bool isRegistration;

  final String username; // Pass this parameter to decide redirection

  OTPVerificationPage(
      {required this.email,
      required this.isRegistration,
      required this.username});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  final int otpLength = 6;
  int remainingTime = 60; // Initial countdown time in seconds
  bool isResendEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> verifyOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join();

    try {
      final response = await http.post(
        Uri.parse(widget.isRegistration
            ? 'http://192.168.31.154:3000/verifySignupOtp'
            : 'http://192.168.31.154:3000/verifyForgotPasswordOtp'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(
            {'email': widget.email, 'username': widget.username, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully!')),
        );

        // Conditional Navigation based on the context
        if (widget.isRegistration) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Loginpage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmPasswordPage(email: widget.email)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid or expired OTP')),
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error verifying OTP')),
      );
    }
  }

  void onConfirmPressed() {
    verifyOTP();
  }

  void onResendPressed() async {
    if (isResendEnabled) {
      setState(() {
        remainingTime = 60;
        isResendEnabled = false;
        _timer?.cancel();
        startResendTimer();
      });

      // Clear OTP inputs
      for (var controller in otpControllers) {
        controller.clear();
      }

      try {
        final response = await http.post(
          Uri.parse('http://192.168.31.154:3000/forgotpwd'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({'email': widget.email}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP resent to your email!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to resend OTP')),
          );
        }
      } catch (e) {
        print('Error resending OTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error resending OTP')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your email to verify your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                otpLength,
                (index) => SizedBox(
                  width: 40,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < otpLength - 1) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index - 1]);
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      counterText: '',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'A code has been sent to your email',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onResendPressed,
              child: Text(
                isResendEnabled
                    ? 'Resend'
                    : 'Resend in ${formatTime(remainingTime)}',
                style: TextStyle(
                  color: isResendEnabled ? Colors.blue : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed:
                  otpControllers.any((controller) => controller.text.isEmpty)
                      ? null
                      : onConfirmPressed,
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

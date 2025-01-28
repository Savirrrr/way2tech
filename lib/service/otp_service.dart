import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class OTPService {
  // Function to verify OTP
  Future<bool> verifyOTP(String email, String username, String otp, bool isRegistration) async {
    final url = Uri.parse("http://localhost:3000/api/auth/verifySignupOtp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "username": username, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"]) {
          return true; 
        } else {
          print("Error: ${data["message"]}");
          return false;
        }
      } else {
        print("Server error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: Failed to connect to server: $e");
      return false;
    }
  }
  // Function to resend OTP
  Future<bool> resendOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error resending OTP: $e');
      return false;
    }
  }

  // Timer logic to handle resend OTP
  Timer startResendTimer(int duration, Function(int) onTimeUpdate, Function onResendEnabled) {
    int remainingTime = duration;
    Timer? timer;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        onTimeUpdate(remainingTime);
      } else {
        onResendEnabled();
        timer.cancel();
      }
    });

    return timer;
  }
}
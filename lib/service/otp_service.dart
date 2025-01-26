import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class OTPService {
  // Function to verify OTP
  Future<bool> verifyOTP(String email, String username, String otp, bool isRegistration) async {
    try {
      final response = await http.post(
        Uri.parse(isRegistration
            ? 'http://localhost:3000/verifySignupOtp'
            : 'http://localhost:3000/verifyForgotPasswordOtp'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'username': username, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  // Function to resend OTP
  Future<bool> resendOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/forgotpwd'),
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
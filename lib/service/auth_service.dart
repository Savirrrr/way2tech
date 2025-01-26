import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:3000';

  // Login function
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emailOrUsername': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Save email to SharedPreferences on successful login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      return true;
    } else {
      return false;
    }
  }

  // Check if the user is already logged in
  Future<String?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  // Logout function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }
  static Future<int> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/resetpassword'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
      }),
    );

    return response.statusCode;
  }
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/forgotpwd'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  
  // Check if the username is already taken
  Future<bool> isUsernameTaken(String username) async {
    try {
      var response = await http.get(
        Uri.parse('$_baseUrl/check-username/$username'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['isTaken'];
      } else {
        throw Exception('Failed to check username');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Sign up the user
  Future<bool> signUpUser(String username, String firstName, String lastName, String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('An error occurred during sign-up: $e');
    }
  }
}
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:3000/api/auth';

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }
  static Future<int> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/resetpassword'),
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
        Uri.parse('http://localhost:3000/api/auth/forgot-password'),
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
Future<bool> checkIfUsernameExists(String email) async {
  final url = Uri.parse("http://localhost:3000/api/user/profile");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data.containsKey("isTaken")) {
        return data["isTaken"]; 
      } else {
        print("Unexpected response format: $data");
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

  Future<bool> signUpUser(String username, String firstName, String lastName, String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/register'),
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
// lib/services/user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:way2techv1/models/user_model.dart';

Future<UserModel> retrieveUserDetails(String email) async {
  final url = Uri.parse('http://localhost:3000/retrieveusername');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error retrieving user details");
    }
  } catch (e) {
    throw Exception("Failed to connect to API");
  }
}
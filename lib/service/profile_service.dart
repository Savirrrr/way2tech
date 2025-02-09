// ignore_for_file: avoid_print

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:way2techv1/models/profile_model.dart';
import 'dart:convert';

class ProfileService {
  static const String _baseUrl = 'http://localhost:3000';

 Future<String?> uploadProfileImage(File image, String email) async {
  try {
    // Check file extension
    final extension = path.extension(image.path).toLowerCase();
    if (!['.jpg', '.jpeg', '.png'].contains(extension)) {
      throw Exception('Invalid file type. Only .jpg, .jpeg, and .png are allowed.');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/api/profile/upload-image'),
    );

    // Add the file with correct mime type
    final mimeType = extension == '.png' ? 'image/png' : 'image/jpeg';
    request.files.add(
      await http.MultipartFile.fromPath(
        'profileImage',
        image.path,
        contentType: MediaType.parse(mimeType) // Explicitly set content type
      ),
    );

    request.fields['email'] = email;

    print("Sending request with file type: $mimeType");
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    
    print("Response status: ${response.statusCode}");
    print("Response body: $responseBody");

    if (response.statusCode == 200) {
      return json.decode(responseBody)['imageUrl'];
    } else {
      throw Exception(json.decode(responseBody)['message'] ?? 'Failed to upload image');
    }
  } catch (e) {
    print('Error uploading image: $e');
    throw Exception('Error uploading profile image: $e');
  }
}
  Future<Profile> getProfile(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/profile/$email'),
      );

      if (response.statusCode == 200) {
        return Profile.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }
}
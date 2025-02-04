import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:way2techv1/models/profile_model.dart';
import 'dart:convert';

class ProfileService {
  static const String _baseUrl = 'http://localhost:3000';

  Future<String?> uploadProfileImage(File image, String email) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/profile/upload-image'),
      );

      request.fields['email'] = email;
      request.files.add(
        await http.MultipartFile.fromPath('profileImage', image.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        return jsonResponse['imageUrl'];
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to upload image');
      }
    } catch (e) {
      print(e);
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
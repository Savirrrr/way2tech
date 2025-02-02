// upload_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  // Change this URL to match your actual backend URL and port
  // static const String _baseUrl = 'http://10.0.2.2:3000'; // For Android emulator
  static const String _baseUrl = 'http://localhost:3000'; // For iOS simulator
  
  static Future<bool> uploadData({
    required String email,
    required String title,
    required String caption,
    File? mediaFile,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Add fields to request
      request.fields.addAll({
        'title': title,
        'caption': caption,
        'email': email,
        'userId': email,
      });

      if (mediaFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('media', mediaFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Upload Error: $e');
      return false;
    }
  }
}


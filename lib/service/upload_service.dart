import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  static const String _uploadUrl = 'http://localhost:3000/api/upload';

  static Future<bool> uploadData({
    required String email,
    required String title,
    required String caption,
    File? mediaFile,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.fields['title'] = title;
      request.fields['caption'] = caption;
      request.fields['email'] = email;

      if (mediaFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('media', mediaFile.path),
        );
      }

      final response = await request.send();

      return response.statusCode == 200;
    } catch (e) {
      print('Upload Error: $e');
      return false;
    }
  }
}
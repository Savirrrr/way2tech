import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:way2techv1/models/upload_model.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api';

  Future<int> retrieveMaxIndex() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/maxIndex'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception(
          "Failed to retrieve max index. Status code: ${response.statusCode}");
    }
  }

  Future<UploadData?> fetchData(int index) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/retreiveData'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'index': index}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UploadData.fromJson(data);
    } else {
      throw Exception(
          "Failed to retrieve data. Status code: ${response.statusCode}");
    }
  }
}
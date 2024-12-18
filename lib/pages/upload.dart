import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:way2techv1/pages/nav_bar.dart';

class UploadPage extends StatefulWidget {
  final String email;
  UploadPage({required this.email});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  bool acceptTerms = false;
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadData() async {
    const String uploadUrl =
        'http://192.168.31.154:3000/upload'; // Update with your backend URL

    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['title'] = titleController.text;
      request.fields['caption'] = captionController.text;
      request.fields['email'] = widget.email;
      // request.fields['userId'] = 'your_user_id'; // Replace with actual userId

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'media',
            _imageFile!.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Data uploaded successfully');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload successful')));
      } else {
        print('Failed to upload data: ${response.statusCode}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload failed')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TITLE:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'text box',
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Caption:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: captionController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'text box',
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Attach file: (mp4/jpg)",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: _imageFile == null
                      ? Center(
                          child: Text("PREVIEW MEDIA",
                              style: TextStyle(color: Colors.black54)))
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: acceptTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        acceptTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "I hereby accept that this news is 100% true",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: acceptTerms ? _uploadData : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    "UPLOAD NOW",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(email: widget.email),
    );
  }
}


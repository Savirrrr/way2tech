import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:way2techv1/service/upload_service.dart';
import 'package:way2techv1/widget/upload_form.dart';
import 'package:way2techv1/widget/navbar.dart';

class UploadPage extends StatefulWidget {
  final String email;

  const UploadPage({Key? key, required this.email}) : super(key: key);

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
    final success = await UploadService.uploadData(
      email: widget.email,
      title: titleController.text,
      caption: captionController.text,
      mediaFile: _imageFile,
    );

    final snackBar = SnackBar(
      content: Text(success ? 'Upload successful' : 'Upload failed'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (success) {
      titleController.clear();
      captionController.clear();
      setState(() {
        _imageFile = null;
        acceptTerms = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
          child: UploadForm(
            titleController: titleController,
            captionController: captionController,
            imageFile: _imageFile,
            acceptTerms: acceptTerms,
            onPickImage: _pickImage,
            onAcceptTerms: (value) {
              setState(() {
                acceptTerms = value ?? false;
              });
            },
            onUpload: _uploadData,
          ),
        ),
      ),
      bottomNavigationBar: Navbar(email: widget.email),
    );
  }
}
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
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  
  bool acceptTerms = false;
  bool isLoading = false;
  File? _imageFile;

  @override
  void dispose() {
    titleController.dispose();
    captionController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadData() async {
    if (titleController.text.isEmpty || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await UploadService.uploadData(
        email: widget.email,
        title: titleController.text,
        caption: captionController.text,
        mediaFile: _imageFile,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Upload successful' : 'Upload failed'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        titleController.clear();
        captionController.clear();
        setState(() {
          _imageFile = null;
          acceptTerms = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
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
                onUpload: isLoading ? null : _uploadData,
                isLoading: isLoading,
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: Navbar(email: widget.email,initialIndex: 1,),
    );
  }
}
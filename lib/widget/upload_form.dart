import 'dart:io';
import 'package:flutter/material.dart';

class UploadForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController captionController;
  final File? imageFile;
  final bool acceptTerms;
  final VoidCallback onPickImage;
  final ValueChanged<bool?> onAcceptTerms;
  final VoidCallback onUpload;

  const UploadForm({
    required this.titleController,
    required this.captionController,
    this.imageFile,
    required this.acceptTerms,
    required this.onPickImage,
    required this.onAcceptTerms,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "TITLE:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter title',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Caption:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: captionController,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter caption',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Attach file: (mp4/jpg)",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[300],
            child: imageFile == null
                ? const Center(
                    child: Text(
                      "PREVIEW MEDIA",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : Image.file(imageFile!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: acceptTerms,
              onChanged: onAcceptTerms,
            ),
            const Expanded(
              child: Text(
                "I hereby accept that this news is 100% true",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: acceptTerms ? onUpload : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Colors.black,
            ),
            child: const Text(
              "UPLOAD NOW",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
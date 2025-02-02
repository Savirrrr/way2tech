import 'dart:io';
import 'package:flutter/material.dart';

class UploadForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController captionController;
  final File? imageFile;
  final bool acceptTerms;
  final bool isLoading;
  final VoidCallback onPickImage;
  final ValueChanged<bool?> onAcceptTerms;
  final VoidCallback? onUpload;

  const UploadForm({
    Key? key,
    required this.titleController,
    required this.captionController,
    this.imageFile,
    required this.acceptTerms,
    required this.onPickImage,
    required this.onAcceptTerms,
    required this.onUpload,
    this.isLoading = false,
  }) : super(key: key);

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
          enabled: !isLoading,
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
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        const Text(
          "Attach file: (mp4/jpg)",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: isLoading ? null : onPickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: imageFile == null
                ? const Center(
                    child: Text(
                      "PREVIEW MEDIA",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(imageFile!, fit: BoxFit.cover),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: acceptTerms,
              onChanged: isLoading ? null : onAcceptTerms,
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
            onPressed: (acceptTerms && !isLoading) ? onUpload : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey,
            ),
            child: Text(
              isLoading ? "UPLOADING..." : "UPLOAD NOW",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
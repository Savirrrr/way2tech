import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:way2techv1/models/upload_model.dart';

class FlipPage extends StatelessWidget {
  final UploadData data;

  const FlipPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          data.mediaUrl.isNotEmpty
              ? Image.memory(
                  base64Decode(data.mediaUrl),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Text("No image available"),
          const SizedBox(height: 8),
          Text(
            data.username,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            data.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.caption,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
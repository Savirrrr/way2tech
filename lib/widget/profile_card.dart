import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:way2techv1/service/profile_service.dart';
import 'dart:io';

class ProfileCard extends StatefulWidget {
  final String email;
  final String fullName;
  final String username;

  const ProfileCard({
    Key? key,
    required this.email,
    required this.fullName,
    required this.username,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  File? _profileImage;
  String? _profileImageUrl;
  final ProfileService _profileService = ProfileService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile(widget.email);
      setState(() {
        _profileImageUrl = profile.profileImageUrl;
      });
    } catch (e) {
      // Handle error (could show a snackbar)
      print('Error loading profile: $e');
    }
  }

  Future<void> _showImageOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Add Image'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage();
                },
              ),
              if (_profileImage != null || _profileImageUrl != null)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Remove Image'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _profileImage = null;
                      _profileImageUrl = null;
                      // TODO: Implement backend call to remove profile image
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        // Upload image to backend
        final imageUrl = await _profileService.uploadProfileImage(
          imageFile,
          widget.email,
        );

        setState(() {
          _profileImage = imageFile;
          _profileImageUrl = imageUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : (_profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : null),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : (_profileImage == null && _profileImageUrl == null
                            ? Icon(Icons.person, size: 50, color: Colors.white)
                            : null),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _isLoading ? null : _showImageOptions,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fullName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.username,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Implement edit profile functionality
                },
              ),
            ],
          ),
          Divider(thickness: 1.0, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
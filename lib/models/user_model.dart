// lib/models/user_model.dart

class UserModel {
  final String email;
  final String username;
  final String firstName;
  final String lastName;

  UserModel({
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  // Factory constructor to create a UserModel from a map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
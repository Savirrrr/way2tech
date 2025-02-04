class UserModel {
  final String username;
  final String firstName;
  final String lastName;

  UserModel({required this.username, required this.firstName, required this.lastName, required String email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    username: json['username'] ?? 'Unknown',
    firstName: json['firstname'] ?? 'Unknown',
    lastName: json['lastname'] ?? 'Unknown', email: json['email']??'',
  );
}
}
class Profile {
  final String email;
  final String fullName;
  final String username;
  final String? profileImageUrl;

  Profile({
    required this.email,
    required this.fullName,
    required this.username,
    this.profileImageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'],
      fullName: json['fullName'],
      username: json['username'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'username': username,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class UploadData {
  final String title;
  final String caption;
  final String username;
  final String mediaUrl;

  UploadData({
    required this.title,
    required this.caption,
    required this.username,
    required this.mediaUrl,
  });

  factory UploadData.fromJson(Map<String, dynamic> json) {
    return UploadData(
      title: json['title'] ?? 'No Title',
      caption: json['text'] ?? 'No Caption',
      username: json['userId'] ?? 'Unknown User',
      mediaUrl: json['media'] != null ? json['media']['data'] : '',
    );
  }
}

class ReverseNumberGenerator {
  int _currentIndex;

  ReverseNumberGenerator(this._currentIndex);

  int? generatePreviousNumber() {
    if (_currentIndex >= 0) {
      return _currentIndex--;
    }
    return null;
  }
}
class User {
  final int id;
  final String username;
  final String firstName;
  final String accessToken;
  final String refreshToken;

const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
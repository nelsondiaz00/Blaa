class User {
  final String email;
  final String photoUrl;
  final String fullName;
  final String phoneNumber;
  final String position;
  final DateTime createdAt;

  User({
    required this.email,
    required this.photoUrl,
    required this.fullName,
    required this.phoneNumber,
    required this.position,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      photoUrl: json['photoUrl'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      position: json['position'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'photoUrl': photoUrl,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'position': position,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

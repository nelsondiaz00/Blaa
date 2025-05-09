class Message {
  final int id;
  final String senderEmail;
  final String recipientEmail;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.senderEmail,
    required this.recipientEmail,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderEmail: json['senderEmail'],
      recipientEmail: json['recipientEmail'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderEmail': senderEmail,
      'recipientEmail': recipientEmail,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

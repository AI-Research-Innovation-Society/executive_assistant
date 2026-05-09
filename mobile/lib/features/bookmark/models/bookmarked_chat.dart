import 'dart:convert';

class BookmarkedChat {
  final String id;
  final String title;
  final List<Map<String, String>> messages;
  final DateTime savedAt;

  BookmarkedChat({
    required this.id,
    required this.title,
    required this.messages,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'messages': messages,
        'savedAt': savedAt.toIso8601String(),
      };

  factory BookmarkedChat.fromJson(Map<String, dynamic> json) {
    return BookmarkedChat(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List)
          .map((m) => Map<String, String>.from(m as Map))
          .toList(),
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }

  String encode() => jsonEncode(toJson());

  static BookmarkedChat decode(String source) =>
      BookmarkedChat.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

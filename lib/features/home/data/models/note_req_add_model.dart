class NoteRustAddModel {
  final String title;
  final String content;
  final String? userId;

  NoteRustAddModel({
    required this.title,
    required this.content,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'users_id': userId,
    };
  }
}
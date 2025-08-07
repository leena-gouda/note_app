class NoteReqAddModel {
  final String title;
  final String content;
  final String? userId;

  NoteReqAddModel({
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
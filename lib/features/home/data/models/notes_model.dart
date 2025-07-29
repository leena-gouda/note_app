class NotesModel {
  String? noteId;
  String? title;
  String? content;
  String? usersId;
  String? createdAt;
  String? updatedAt;

  NotesModel(
      {this.noteId,
        this.title,
        this.content,
        this.usersId,
        this.createdAt,
        this.updatedAt});

  NotesModel.fromJson(Map<String, dynamic> json) {
    noteId = json['note_id'].toString();
    title = json['title'];
    content = json['content'];
    usersId = json['users_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note_id'] = noteId;
    data['title'] = title;
    data['content'] = content;
    data['users_id'] = usersId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
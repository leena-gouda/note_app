class NotesModel {
  final String? noteId;
  final String? title;
  final String? content;
  final String? usersId;
  final String? createdAt;
  final String? updatedAt;
  final bool isDeleted;
  final String? deletedAt;
  final bool isFavorite;
  final bool isHidden;

  NotesModel({
    this.noteId,
    this.title,
    this.content,
    this.usersId,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.isFavorite = false,
    this.isHidden = false,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      noteId: json['note_id']?.toString(),
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      usersId: json['users_id']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      isDeleted: (json['is_deleted'] as int?) == 0,
      deletedAt: json['deleted_at']?.toString(),
      isFavorite: (json['is_favorite'] as int?) == 1,
      isHidden: (json['is_hidden'] as int?) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'title': title,
      'content': content,
      'users_id': usersId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_deleted': isDeleted,
      'deleted_at': deletedAt,
      'is_favorite': isFavorite ? 1 : 0,
      'is_hidden': isHidden ? 1 : 0,
    };
  }

  NotesModel copyWith({
    String? noteId,
    String? title,
    String? content,
    String? usersId,
    String? createdAt,
    String? updatedAt,
    bool? isDeleted,
    String? deletedAt,
    bool? isFavorite,
    bool? isHidden,
  }) {
    return NotesModel(
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      content: content ?? this.content,
      usersId: usersId ?? this.usersId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted:  isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
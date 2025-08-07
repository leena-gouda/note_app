class UserModel {
  int? id;
  String? username;
  String? email;
  String? created;

  UserModel({this.id, this.username, this.email, this.created});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['created'] = created;
    return data;
  }
}
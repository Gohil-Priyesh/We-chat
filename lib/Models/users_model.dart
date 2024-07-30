

class usersModel {
  String? image;
  String? pushToke;
  String? about;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? id;
  String? lastActive;
  String? email;

  usersModel(
      {this.image,
        this.pushToke,
        this.about,
        this.name,
        this.createdAt,
        this.isOnline,
        this.id,
        this.lastActive,
        this.email});

  usersModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    pushToke = json['push_toke'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['image'] = image;
    data['push_toke'] = pushToke;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    return data;
  }
}
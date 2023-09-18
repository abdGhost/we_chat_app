class ChatUser {
  String? about;
  String? createdAt;
  String? email;
  String? id;
  String? image;
  bool? isOnline;
  String? lastActive;
  String? name;
  String? pushToken;

  ChatUser({
    this.about,
    this.createdAt,
    this.email,
    this.id,
    this.image,
    this.isOnline,
    this.lastActive,
    this.name,
    this.pushToken,
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    createdAt = json['created_at'];
    email = json['email'];
    id = json['id'];
    image = json['image'];
    isOnline = json['isOnline'];
    lastActive = json['last_active'];
    name = json['name'];
    pushToken = json['push_token'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['about'] = about;
    data['created_at'] = createdAt;
    data['email'] = email;
    data['id'] = id;
    data['image'] = image;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['name'] = name;
    data['push_token'] = pushToken;

    return data;
  }
}

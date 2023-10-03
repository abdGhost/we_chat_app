enum Type {
  text,
  image,
}

class Message {
  late final String toId;
  late final String fromId;
  late final String message;
  late final String read;
  late final Type type;
  late final String? sent;

  Message({
    required this.toId,
    required this.fromId,
    required this.message,
    required this.read,
    required this.type,
    required this.sent,
  });

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    fromId = json['fromId'].toString();
    message = json['message'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['toId'] = toId;
    data['fromId'] = fromId;
    data['message'] = message;
    data['read'] = read;
    data['type'] = type.name;
    data['sent'] = sent;

    return data;
  }
}

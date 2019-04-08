import 'dart:convert';

Memo memoFromJson(String str) {
  final jsonData = json.decode(str);
  return Memo.fromMap(jsonData);
}

String memoToJson(Memo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Memo {
  int id;
  String title;
  String content;
  String createdAt;
  String updatedAt;
  bool deleted;

  Memo(
      {this.id,
      this.title,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.deleted});

  factory Memo.fromMap(Map<String, dynamic> json) => new Memo(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deleted": deleted,
      };
}

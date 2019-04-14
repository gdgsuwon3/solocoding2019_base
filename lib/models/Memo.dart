import 'dart:convert';

import 'package:flutter/cupertino.dart';

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
  String updatedAt;
  int isDeleted;

  Memo(
      {this.id,
      this.title,
      this.content,
      this.updatedAt,
      this.isDeleted});

  factory Memo.fromMap(Map<String, dynamic> json) => new Memo(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        updatedAt: json["updatedAt"],
        isDeleted: json["isDeleted"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "updatedAt": updatedAt,
        "isDeleted": isDeleted == null ? 0 : isDeleted,
      };
}

import 'dart:convert';

class PostModel {
  int? userId;
  int? id;
  String? title;
  String? body;
  bool isRead;

  PostModel({
    this.userId,
    this.id,
    this.title,
    this.body,
    this.isRead = false,
  });

  factory PostModel.fromRawJson(String str) =>
      PostModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
        isRead: false,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
        'isRead': isRead,
      };
}

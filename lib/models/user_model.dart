import 'dart:convert';

class UserModel {
  String id;
  String username;
  String password;
  String fullname;
  String phone;
  String email;
  String image;
  bool status;
  int createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
    required this.status,
    required this.createdAt,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        password: json["password"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "password": password,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "status": status,
        "created_at": createdAt,
      };
}

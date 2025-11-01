import 'dart:convert';

class ProductModel {
  String id;
  String name;
  String category;
  int stock;
  int price;
  String description;
  String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        name: json["name"],
        category: json["category"],
        stock: json["stock"],
        price: json["price"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category": category,
        "stock": stock,
        "price": price,
        "description": description,
        "image": image,
      };
}

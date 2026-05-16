
import 'dart:convert';

Product productFromMap(String str) => Product.fromMap(json.decode(str));

String productToMap(Product data) => json.encode(data.toMap());

class Product {
  List<ProductElement> products;
  int total;
  int skip;
  int limit;

  Product({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    products: List<ProductElement>.from(json["products"].map((x) => ProductElement.fromMap(x))),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toMap() => {
    "products": List<dynamic>.from(products.map((x) => x.toMap())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class ProductElement {
  int id;
  String title;
  String description;
  String category;
  double price;
  String thumbnail;

  ProductElement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.thumbnail,
  });

  factory ProductElement.fromMap(Map<String, dynamic> json) => ProductElement(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    category: json["category"],
    price: json["price"]?.toDouble(),
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "price": price,
    "thumbnail": thumbnail,
  };
}

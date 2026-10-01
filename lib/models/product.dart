class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnailUrl;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnailUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnailUrl: json['thumbnail'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnail': thumbnailUrl,
    };
  }
}
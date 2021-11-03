class Product {
  String name;
  int quantity;
  double? price;

  Product({required this.name, required this.quantity});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity};
  }
}

class Product {
  String name;
  int quantity;
  double? price;
  bool isBought = false;

  Product(
      {required this.name,
      required this.quantity,
      this.price,
      this.isBought = false});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        name: map['name'],
        quantity: map['quantity'],
        price: map['price'],
        isBought: map['isBought']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'isBought': isBought
    };
  }
}

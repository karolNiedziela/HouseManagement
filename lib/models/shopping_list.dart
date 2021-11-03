import 'package:housemanagement/models/product.dart';
import 'package:intl/intl.dart';

class ShoppingList {
  String name;
  List<Product> products = <Product>[];
  String userUId;
  String userFullName;
  DateTime dateCreated;
  late String? docId;

  ShoppingList(
      {required this.name,
      required this.userUId,
      required this.userFullName,
      required this.dateCreated});

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
        name: map['name'],
        userUId: map['userUId'],
        userFullName: map['userFullName'],
        dateCreated: DateTime.parse(map['dateCreated']));
  }

  factory ShoppingList.fromMapWithProducts(Map<String, dynamic> map) {
    var shoppingList = ShoppingList.fromMap(map);

    shoppingList.products = (map['products'] as List)
        .map((product) => Product.fromMap(product))
        .toList();
    return shoppingList;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userUId': userUId,
      'userFullName': userFullName,
      'products': products.map((product) => product.toMap()).toList(),
      'dateCreated': DateFormat('yyyy-MM-dd').format(dateCreated)
    };
  }
}

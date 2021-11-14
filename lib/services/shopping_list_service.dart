import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housemanagement/models/product.dart';
import 'package:housemanagement/models/shopping_list.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/services/user_service.dart';

class ShoppingListService {
  final shoppingListCollection =
      FirebaseFirestore.instance.collection('shoppingLists');

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  Stream<List<ShoppingList>> getShoppingLists(
      List<String> userIds, String startDate, String endDate,
      {bool isDone = false}) {
    return shoppingListCollection
        .where('userUId', whereIn: userIds)
        .where('dateCreated', isGreaterThanOrEqualTo: startDate)
        .where('dateCreated', isLessThanOrEqualTo: endDate)
        .where('isDone', isEqualTo: isDone)
        .snapshots()
        .map(_shoppingListFromSnapshot);
  }

  List<ShoppingList> _shoppingListFromSnapshot(QuerySnapshot snapshot) {
    var shoppingLists = snapshot.docs.map((doc) {
      var shoppingList =
          ShoppingList.fromMapWithProducts(doc.data() as Map<String, dynamic>);
      shoppingList.docId = doc.id;
      return shoppingList;
    }).toList();
    return shoppingLists;
  }

  Stream<List<Product>> getProducts(String docId) {
    return shoppingListCollection
        .doc(docId)
        .snapshots()
        .map(_productListFromSnapshot);
  }

  List<Product> _productListFromSnapshot(DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;
    var products = (map['products'] as List)
        .map((product) => Product.fromMap(product))
        .toList();
    return products;
  }

  Future createShoppingList(String name) async {
    var appUser = await _userService.getByUId(_authService.uid);
    var shoppingList = ShoppingList(
        name: name,
        userUId: appUser.uid,
        userFullName: "${appUser.firstName} ${appUser.secondName}",
        dateCreated: DateTime.now(),
        isDone: false);

    await shoppingListCollection.doc().set(shoppingList.toMap());
  }

  Future addProduct(String docId, String name, int quantity) async {
    var product = Product(name: name, quantity: quantity);
    await shoppingListCollection.doc(docId).update({
      'products': FieldValue.arrayUnion([product.toMap()]),
    });
  }

  Future buyProduct(String documentId, String name) async {
    var shoppingList = ShoppingList.fromMapWithProducts(
        (await shoppingListCollection.doc(documentId).get()).data()!);

    shoppingList.products.map((product) {
      if (product.name == name) {
        product.isBought = true;
      }
      return product;
    }).toList();

    await shoppingListCollection.doc(documentId).update({
      'products':
          shoppingList.products.map((product) => product.toMap()).toList()
    });
  }

  Future setPriceOfProduct(
      String documentId, String productName, double price) async {
    var shoppingList = ShoppingList.fromMapWithProducts(
        (await shoppingListCollection.doc(documentId).get()).data()!);

    shoppingList.products.map((product) {
      if (product.name == productName) {
        product.price = price;
      }
    }).toList();

    await shoppingListCollection.doc(documentId).update({
      'products':
          shoppingList.products.map((product) => product.toMap()).toList()
    });
  }

  Future deleteShoppingList(String documentId) async {
    await shoppingListCollection.doc(documentId).delete();
  }

  Future deleteProduct(String documentId, Product product) async {
    await shoppingListCollection.doc(documentId).update({
      'products': FieldValue.arrayRemove([product.toMap()]),
    });
  }

  Future acceptShoppingList(String documentId) async {
    await shoppingListCollection.doc(documentId).update({'isDone': true});
  }
}

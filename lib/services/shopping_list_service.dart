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

  Stream<List<ShoppingList>> get shoppingLists {
    return shoppingListCollection
        .where('userUId', isEqualTo: _authService.uid)
        .snapshots()
        .map(_shoppingListFromSnapshot);
  }

  List<ShoppingList> _shoppingListFromSnapshot(QuerySnapshot snapshot) {
    var shoppingLists = snapshot.docs.map((doc) {
      var shoppingList = ShoppingList(
          name: doc.get('name') ?? '',
          userUId: doc.get('userUId') ?? '',
          userFullName: doc.get('userFullName') ?? '',
          dateCreated: DateTime.parse(doc.get('dateCreated')));
      shoppingList.products = (doc.get("products") as List)
          .map((product) => Product.fromMap(product))
          .toList();
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
        dateCreated: DateTime.now());

    await shoppingListCollection.doc().set(shoppingList.toMap());
  }

  Future addProduct(String docId, String name, int quantity) async {
    var product = Product(name: name, quantity: quantity);
    await shoppingListCollection.doc(docId).update({
      'products': FieldValue.arrayUnion([product.toMap()]),
    });
  }
}

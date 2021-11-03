import 'package:flutter/material.dart';
import 'package:housemanagement/models/shopping_list.dart';
import 'package:housemanagement/screens/shoppingList/shopping_list_tile.dart';
import 'package:provider/provider.dart';

class ShoppingListList extends StatefulWidget {
  const ShoppingListList({Key? key}) : super(key: key);

  @override
  _ShoppingListListState createState() => _ShoppingListListState();
}

class _ShoppingListListState extends State<ShoppingListList> {
  @override
  Widget build(BuildContext context) {
    final shoppingLists = Provider.of<List<ShoppingList>>(context);

    return GridView.builder(
      itemCount: shoppingLists.length > 0 ? shoppingLists.length : 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 22.0 / 10.0, crossAxisCount: 2),
      itemBuilder: ((context, index) {
        return ShoppingListTile(shoppingList: shoppingLists[index]);
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:housemanagement/models/shopping_list.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;

  const ShoppingListTile({Key? key, required this.shoppingList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/shoppinglistdetails', arguments: {
          'docId': shoppingList.docId,
          'name': shoppingList.name
        });
      },
      child: Card(
          color: Colors.blueAccent[100],
          semanticContainer: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(shoppingList.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.0)),
                Text(shoppingList.userFullName),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("0 / ${shoppingList.products.length.toString()}")
                  ],
                )
              ],
            ),
          )),
    );
  }
}

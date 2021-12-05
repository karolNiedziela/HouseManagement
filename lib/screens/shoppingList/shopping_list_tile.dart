import 'package:flutter/material.dart';
import 'package:housemanagement/core/font_sizes.dart';
import 'package:housemanagement/models/shopping_list.dart';
import 'package:housemanagement/core/routes.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;

  const ShoppingListTile({Key? key, required this.shoppingList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.shoppingListDetails,
            arguments: shoppingList);
      },
      child: Card(
          semanticContainer: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Text(shoppingList.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSizes.big,
                          color: Theme.of(context).textTheme.bodyText1!.color)),
                ),
                Text(
                  shoppingList.userFullName,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    shoppingList.products.isEmpty
                        ? Text(
                            'Brak produktów',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          )
                        : Text(
                            "${shoppingList.products.where((product) => product.isBought).toList().length} / ${shoppingList.products.length.toString()}",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

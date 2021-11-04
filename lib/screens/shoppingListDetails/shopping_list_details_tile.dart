import 'package:flutter/material.dart';
import 'package:housemanagement/models/product.dart';
import 'package:housemanagement/services/shopping_list_service.dart';
import 'package:housemanagement/widgets/trailing_popup_menu_widget.dart';

class ShoppingListDetailsTile extends StatefulWidget {
  final Product product;
  final String docId;

  const ShoppingListDetailsTile(
      {Key? key, required this.product, required this.docId})
      : super(key: key);

  @override
  _ShoppingListDetailsTileState createState() =>
      _ShoppingListDetailsTileState();
}

class _ShoppingListDetailsTileState extends State<ShoppingListDetailsTile> {
  final ShoppingListService _shoppingListService = ShoppingListService();

  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.product.isBought ? Colors.grey[400] : null,
        child: ListTile(
          dense: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.product.name,
                  style: TextStyle(
                      fontSize: 17,
                      decoration: widget.product.isBought
                          ? TextDecoration.lineThrough
                          : null)),
              Text(
                "${widget.product.quantity}",
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
          subtitle: widget.product.isBought
              ? Text(
                  "Cena: ${widget.product.price! * widget.product.quantity}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                )
              : null,
          trailing: const TrailingPopupMenuWidget(),
          onTap: () async {
            await _shoppingListService.buyProduct(
                widget.docId, widget.product.name, 10);
          },
        ));
  }
}

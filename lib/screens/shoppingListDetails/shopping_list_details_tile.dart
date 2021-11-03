import 'package:flutter/material.dart';
import 'package:housemanagement/models/product.dart';

class ShoppingListDetailsTile extends StatefulWidget {
  final Product product;

  const ShoppingListDetailsTile({Key? key, required this.product})
      : super(key: key);

  @override
  _ShoppingListDetailsTileState createState() =>
      _ShoppingListDetailsTileState();
}

class _ShoppingListDetailsTileState extends State<ShoppingListDetailsTile> {
  bool isBought = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: isBought ? Colors.grey[400] : null,
        child: ListTile(
          dense: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.product.name,
                  style: TextStyle(
                      fontSize: 17,
                      decoration:
                          isBought ? TextDecoration.lineThrough : null)),
              Text(
                "${widget.product.quantity}",
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
          subtitle: isBought ? const Text('kupione') : null,
          trailing: PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(child: Text('Edit')),
              const PopupMenuItem(child: Text('Delete'))
            ],
          ),
          onTap: () => setState(() {
            isBought = !isBought;
          }),
        ));
  }
}

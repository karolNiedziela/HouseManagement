import 'package:flutter/material.dart';
import 'package:housemanagement/models/product.dart';
import 'package:housemanagement/services/shopping_list_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:housemanagement/widgets/textFormFields/positive_number_text_form_field_widget.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';

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
  final _setPriceFormKey = GlobalKey<FormState>();
  final priceTextEditingController = TextEditingController();
  final _editFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final priceField = PositiveNumberTextFormFieldWidget(
        controller: priceTextEditingController, hintText: 'Cena');

    final submitButton = getSubmitButton(SubmitButtonWidget(
        onPressed: () async {
          await _shoppingListService.setPriceOfProduct(
              widget.docId,
              widget.product.name,
              double.parse(priceTextEditingController.text));
          Navigator.of(context).pop();
        },
        displayButtonText: 'Dodaj'));

    return Card(
        color: widget.product.isBought ? Colors.indigo[100] : null,
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
          subtitle: widget.product.isBought && widget.product.price != null
              ? Text(
                  "Zapłacano: ${widget.product.price != null ? widget.product.price! * widget.product.quantity : ''}zł",
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                )
              : null,
          trailing: widget.product.isBought
              ? PopupMenuWidget(
                  editAction: () {
                    FormDialog.showFormDialog(
                        context: context,
                        formContent: [],
                        key: _editFormKey,
                        dialogHeader: "Edytuj");
                  },
                  deleteAction: () async {
                    await _shoppingListService.deleteProduct(
                        widget.docId, widget.product);
                  },
                  additionalPopupMenuItems: [
                    AdditionalPopupMenuItem(
                        onTap: () {
                          FormDialog.showFormDialog(
                              context: context,
                              formContent: [priceField, submitButton],
                              key: _setPriceFormKey,
                              dialogHeader: 'Podaj cenę');
                        },
                        text: 'Ustaw cenę')
                  ],
                )
              : PopupMenuWidget(deleteAction: () async {
                  await _shoppingListService.deleteProduct(
                      widget.docId, widget.product);
                }),
          onTap: () async {
            await _shoppingListService.buyProduct(
                widget.docId, widget.product.name);
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';
import 'package:housemanagement/models/product.dart';
import 'package:housemanagement/services/shopping_list_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:housemanagement/widgets/textFormFields/base_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/positive_number_text_form_field_widget.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';

class ShoppingListDetailsTile extends StatefulWidget {
  final Product product;
  final String docId;
  final bool isDone;

  const ShoppingListDetailsTile(
      {Key? key,
      required this.product,
      required this.docId,
      required this.isDone})
      : super(key: key);

  @override
  _ShoppingListDetailsTileState createState() =>
      _ShoppingListDetailsTileState();
}

class _ShoppingListDetailsTileState extends State<ShoppingListDetailsTile> {
  final ShoppingListService _shoppingListService = ShoppingListService();
  final _setPriceFormKey = GlobalKey<FormState>();
  final priceTextEditingController = TextEditingController();
  final quantityTextEditingController = TextEditingController();
  final nameTextEditingController = TextEditingController();
  final _editFormKey = GlobalKey<FormState>();
  late PositiveNumberTextFormFieldWidget priceField;
  late Material submitButton;
  late BaseTextFormFieldWidget nameField;
  late PositiveNumberTextFormFieldWidget quantityField;
  late Material editSubmitButton;
  String? _validationMessage;

  @override
  void initState() {
    priceField = PositiveNumberTextFormFieldWidget(
        controller: priceTextEditingController, hintText: 'Cena');

    submitButton = getSubmitButton(SubmitButtonWidget(
        onPressed: () async {
          await _shoppingListService.setPriceOfProduct(
              widget.docId,
              widget.product.name,
              double.parse(priceTextEditingController.text));
          Navigator.of(context).pop();
        },
        displayButtonText: 'Dodaj'));

    quantityField = PositiveNumberTextFormFieldWidget(
        controller: quantityTextEditingController, hintText: "Ilość");

    editSubmitButton = getSubmitButton(SubmitButtonWidget(
        onPressed: () async {
          if (await _shoppingListService.productExists(
              widget.docId, nameTextEditingController.text,
              previousName: widget.product.name)) {
            setState(() {
              _validationMessage =
                  "Produkt o podanej nazwie już jest na liście.";
            });
          } else {
            setState(() {
              _validationMessage = null;
            });
          }
          if (_editFormKey.currentState!.validate()) {
            await _shoppingListService.updateProduct(
                widget.docId,
                widget.product.name,
                nameTextEditingController.text,
                int.parse(quantityTextEditingController.text));
            Navigator.of(context).pop();
          }
        },
        displayButtonText: 'Edytuj'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.product.isBought ? AppColors.primaryColorLight : null,
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
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.blackColor),
                )
              : null,
          trailing: _buildTrailing(),
          onTap: () async {
            await _shoppingListService.buyProduct(
                widget.docId, widget.product.name);
          },
        ));
  }

  Widget? _buildTrailing() {
    if (widget.isDone) {
      return null;
    }

    if (widget.product.isBought) {
      return PopupMenuWidget(
        editAction: () {
          setState(() {
            nameTextEditingController.text = widget.product.name;
            quantityTextEditingController.text =
                widget.product.quantity.toString();
          });

          FormDialog.showFormDialog(
              context: context,
              formContent: [nameField, quantityField, editSubmitButton],
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
      );
    } else {
      return PopupMenuWidget(deleteAction: () async {
        await _shoppingListService.deleteProduct(widget.docId, widget.product);
      });
    }
  }
}

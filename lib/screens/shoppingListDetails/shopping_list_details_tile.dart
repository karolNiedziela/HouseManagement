import 'package:flutter/material.dart';
import 'package:housemanagement/core/base_colors.dart';
import 'package:housemanagement/core/font_sizes.dart';
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
  Widget build(BuildContext context) {
    nameField = BaseTextFormFieldWidget(
        controller: nameTextEditingController,
        hintText: 'Nazwa',
        prefixIcon: Icons.shopping_bag,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value!.isEmpty) {
            return "Wprowad?? nazw??.";
          }

          if (_validationMessage != null) {
            return _validationMessage;
          }
          return null;
        });

    priceField = PositiveNumberTextFormFieldWidget(
        controller: priceTextEditingController, hintText: 'Cena');

    submitButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        await _shoppingListService.setPriceOfProduct(widget.docId,
            widget.product.name, double.parse(priceTextEditingController.text));
        Navigator.of(context).pop();
      },
      displayButtonText: 'Dodaj',
      context: context,
    ));

    quantityField = PositiveNumberTextFormFieldWidget(
        controller: quantityTextEditingController, hintText: "Ilo????");

    editSubmitButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        if (await _shoppingListService.productExists(
            widget.docId, nameTextEditingController.text,
            previousName: widget.product.name)) {
          setState(() {
            _validationMessage = "Produkt o podanej nazwie ju?? jest na li??cie.";
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
      displayButtonText: 'Edytuj',
      context: context,
    ));

    return Card(
        color: widget.product.isBought
            ? Theme.of(context).bottomNavigationBarTheme.backgroundColor
            : null,
        child: ListTile(
          dense: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.product.name,
                  style: TextStyle(
                      fontSize: AppFontSizes.big,
                      decoration: widget.product.isBought
                          ? TextDecoration.lineThrough
                          : null)),
              Text(
                "${widget.product.quantity}",
                style: const TextStyle(fontSize: AppFontSizes.big),
              ),
            ],
          ),
          subtitle: widget.product.isBought && widget.product.price != null
              ? Text(
                  "Zap??acano: ${widget.product.price != null ? widget.product.price! * widget.product.quantity : ''}z??",
                  style: const TextStyle(
                      fontSize: AppFontSizes.normal,
                      color: AppBaseColors.blackColor),
                )
              : null,
          trailing: _buildTrailing(),
          onTap: () async {
            if (widget.product.isBought) {
              FormDialog.showConfirmDeleteDialog(
                  context: context,
                  onYesPressed: () async {
                    await _shoppingListService.buyOrUndoProduct(widget.docId,
                        widget.product.name, widget.product.isBought);
                  },
                  text: "Na pewno chcesz cofn???? zakup produktu?");
            } else {
              await _shoppingListService.buyOrUndoProduct(
                  widget.docId, widget.product.name, widget.product.isBought);
            }
          },
        ));
  }

  Widget? _buildTrailing() {
    if (widget.isDone) {
      return null;
    }

    if (widget.product.isBought) {
      return PopupMenuWidget(
        isEditVisible: false,
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
                    dialogHeader: 'Podaj cen??');
              },
              text: 'Ustaw cen??')
        ],
      );
    } else {
      return PopupMenuWidget(editAction: () {
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
      }, deleteAction: () async {
        await _shoppingListService.deleteProduct(widget.docId, widget.product);
      });
    }
  }
}

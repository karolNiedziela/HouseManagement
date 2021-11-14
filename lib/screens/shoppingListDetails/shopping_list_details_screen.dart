import 'package:flutter/material.dart';
import 'package:housemanagement/models/shopping_list.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/models/product.dart';
import 'package:housemanagement/screens/shoppingListDetails/shopping_list_details_tile.dart';
import 'package:housemanagement/services/shopping_list_service.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';
import 'package:housemanagement/widgets/textFormFields/name_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/positive_number_text_form_field_widget.dart';

class ShoppingListDetailsScreen extends StatefulWidget {
  const ShoppingListDetailsScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListDetailsScreenState createState() =>
      _ShoppingListDetailsScreenState();
}

class _ShoppingListDetailsScreenState extends State<ShoppingListDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late ShoppingList shoppingList;

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController quantityEditingController =
      TextEditingController();

  final ShoppingListService _shoppingListService = ShoppingListService();

  @override
  Widget build(BuildContext context) {
    setState(() {
      shoppingList = ModalRoute.of(context)!.settings.arguments as ShoppingList;
    });

    final nameField = NameTextFormFieldWidget(
        controller: nameEditingController,
        hintText: 'Nazwa',
        iconData: Icons.shopping_bag);

    final quantityField = PositiveNumberTextFormFieldWidget(
        controller: quantityEditingController, hintText: 'Ilość');

    final addButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await _shoppingListService.addProduct(
              shoppingList.docId!,
              nameEditingController.text,
              int.parse(quantityEditingController.text));
          Navigator.pop(context);
        }
      },
      displayButtonText: 'Dodaj',
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
        centerTitle: true,
        actions: <Widget>[
          getPopupMenuWidget(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 13,
            child: StreamBuilder(
              stream: ShoppingListService().getProducts(shoppingList.docId!),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasError) {
                  return const Text("error");
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ShoppingListDetailsTile(
                              product: snapshot.data![index],
                              docId: shoppingList.docId!);
                        });
                  }

                  return const Text('no data');
                }
              },
            ),
          ),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () async {
                          nameField.controller.clear();
                          quantityEditingController.text = "1";
                          FormDialog.showFormDialog(
                              context: context,
                              formContent: [
                                nameField,
                                quantityField,
                                addButton
                              ],
                              key: _formKey,
                              dialogHeader: 'Produkt');

                          setState(() {});
                        },
                        child: const Icon(Icons.add),
                      )
                    ]),
              ))
        ],
      ),
    );
  }

  Widget getPopupMenuWidget() {
    if (shoppingList.isDone) {
      return PopupMenuWidget(
        deleteAction: _deleteAction,
        isEditVisible: false,
      );
    }

    return PopupMenuWidget(
      deleteAction: _deleteAction,
      isEditVisible: false,
      additionalPopupMenuItems: [
        AdditionalPopupMenuItem(
            onTap: () {
              FormDialog.showConfirmDeleteDialog(
                  context: context,
                  onYesPressed: () async {
                    await _shoppingListService
                        .acceptShoppingList(shoppingList.docId!);
                    Navigator.of(context).pop();
                  },
                  text: 'Czy jesteś pewien, że chcesz zaakceptować listę?');
            },
            text: 'Zaakceptuj')
      ],
    );
  }

  void _deleteAction() async {
    await _shoppingListService.deleteShoppingList(shoppingList.docId!);
    Navigator.of(context).pop();
  }
}

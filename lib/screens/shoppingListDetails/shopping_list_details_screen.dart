import 'package:flutter/material.dart';
import 'package:housemanagement/constants/app_constants.dart';
import 'package:housemanagement/models/product.dart';
import 'package:housemanagement/screens/shoppingListDetails/shopping_list_details_tile.dart';
import 'package:housemanagement/services/shopping_list_service.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
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

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController quantityEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    final ShoppingListService _shoppingListService = ShoppingListService();
    bool isBought = false;
    final nameField = NameTextFormFieldWidget(
        controller: nameEditingController,
        hintText: 'Name',
        iconData: Icons.shopping_bag);

    final quantityField = PositiveNumberTextFormFieldWidget(
        controller: quantityEditingController, hintText: 'Quantity');

    final addButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await _shoppingListService.addProduct(
              arguments['docId'],
              nameEditingController.text,
              int.parse(quantityEditingController.text));

          Navigator.pop(context);
        }
      },
      displayButtonText: 'Add',
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['name']),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: StreamBuilder(
              stream: ShoppingListService().getProducts(arguments['docId']),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasError) {
                  return const Text("error");
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ShoppingListDetailsTile(
                              product: snapshot.data![index]);
                        });
                  }

                  return Text('no data');
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
                          FormDialog.showFormDialog(
                              context: context,
                              formContent: [
                                nameField,
                                quantityField,
                                addButton
                              ],
                              key: _formKey,
                              dialogHeader: 'Product');
                        },
                        child: const Icon(Icons.add),
                        backgroundColor: Colors.blueAccent[200],
                      )
                    ]),
              ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:housemanagement/models/shopping_list.dart';
import 'package:housemanagement/screens/shoppingList/shopping_list_list.dart';
import 'package:housemanagement/services/household_service.dart';
import 'package:housemanagement/services/shopping_list_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/utils/loading_element.dart';
import 'package:housemanagement/widgets/textFormFields/name_text_form_field_widget.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final shoppingListNameEditingController = TextEditingController();
  final now = DateTime.now();
  late DateTime startDate = DateTime(now.year, now.month, 1);
  late DateTime endDate = DateTime(now.year, now.month, now.day);

  @override
  Widget build(BuildContext context) {
    final ShoppingListService _shoppingListService = ShoppingListService();

    final _formKey = GlobalKey<FormState>();
    final shoppingListNameField = NameTextFormFieldWidget(
        controller: shoppingListNameEditingController,
        hintText: 'Nazwa',
        iconData: Icons.list);

    final addButton = getSubmitButton(SubmitButtonWidget(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await _shoppingListService
              .createShoppingList(shoppingListNameEditingController.text);

          Navigator.pop(context);
        }
      },
      displayButtonText: 'Dodaj',
    ));

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () async {
                      final picked = (await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2019),
                          lastDate: DateTime(now.year, now.month + 1, 1),
                          initialDateRange:
                              DateTimeRange(start: startDate, end: endDate),
                          initialEntryMode: DatePickerEntryMode.inputOnly,
                          locale: const Locale('pl', 'PL')));

                      if (picked != null) {
                        setState(() {
                          startDate = picked.start;
                          endDate = picked.end;
                        });
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Wybierz zakres:',
                            style:
                                TextStyle(color: Colors.black, fontSize: 17)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.calendar_today,
                                color: Colors.indigo),
                            const SizedBox(width: 10),
                            getShortDate(),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: FutureBuilder(
            future: HouseholdService().getUserIds(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingElement();
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return StreamProvider<List<ShoppingList>>.value(
                      initialData: const [],
                      value: ShoppingListService().getShoppingLists(
                          snapshot.data!,
                          getStringShortDate(startDate),
                          getStringShortDate(endDate)),
                      child: const ShoppingListList());
                }
              }

              return const Text('');
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    shoppingListNameField.controller.clear();
                    FormDialog.showFormDialog(
                        context: context,
                        formContent: [shoppingListNameField, addButton],
                        key: _formKey,
                        dialogHeader: 'Lista zakupów');
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.blueAccent[200],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getShortDate() {
    return Text(
      "${DateFormat('yyyy-MM-dd').format(startDate)} - ${DateFormat('yyyy-MM-dd').format(endDate)}",
      style: const TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  String getStringShortDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housemanagement/core/colors.dart';
import 'package:housemanagement/models/bill.dart';
import 'package:housemanagement/screens/bills/bills_list_tile.dart';
import 'package:housemanagement/services/bills_service.dart';
import 'package:housemanagement/services/household_service.dart';
import 'package:housemanagement/shared/shared_styles.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/utils/loading_element.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';
import 'package:housemanagement/widgets/textFormFields/base_text_form_field_widget.dart';
import 'package:housemanagement/widgets/textFormFields/positive_number_text_form_field_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({Key? key}) : super(key: key);

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final BillsService _billsService = BillsService();
  final _formKey = GlobalKey<FormState>();
  final kToday = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<Bill>> _groupedBills =
      LinkedHashMap<DateTime, List<Bill>>();

  final billNameEditingController = TextEditingController();
  final serviceProviderEditingController = TextEditingController();
  final dateOfPaymentEditingController = TextEditingController();
  final amountEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(kToday.year, kToday.month - 3, 1);
    final lastDay = DateTime(kToday.year, kToday.month + 3, 0);

    final billNameField = BaseTextFormFieldWidget(
      controller: billNameEditingController,
      hintText: 'Tytuł',
      prefixIcon: Icons.list,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Wprowadź tytuł.";
        }

        return null;
      },
    );

    final serviceProviderNameField = BaseTextFormFieldWidget(
      controller: serviceProviderEditingController,
      hintText: 'Dostawca usługi',
      prefixIcon: Icons.list,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return "Wprowadź dostawcę usługi.";
        }

        return null;
      },
    );

    final dateOfPaymentField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        autofocus: false,
        controller: dateOfPaymentEditingController,
        decoration: getInputDecoration(Icons.calendar_today, 'Data zapłaty'),
        readOnly: true,
      ),
    );

    final amountField = PositiveNumberTextFormFieldWidget(
        controller: amountEditingController,
        hintText: 'Wysokość opłaty',
        iconData: Icons.price_change);

    final addButton = getSubmitButton(SubmitButtonWidget(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await _billsService.addBill(
                billNameEditingController.text,
                serviceProviderEditingController.text,
                double.parse(amountEditingController.text),
                dateOfPaymentEditingController.text);
            Navigator.of(context).pop();
          }
        },
        displayButtonText: 'Dodaj'));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Rachunki'),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        drawer: const DrawerWidget(),
        body: FutureBuilder(
            future: HouseholdService().getUserIds(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('');
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return StreamBuilder(
                      stream: _billsService.getAllBills(snapshot.data!),
                      builder: (context, AsyncSnapshot<List<Bill>> snapshot) {
                        if (snapshot.hasData) {
                          final bills = snapshot.data;
                          _groupBills(bills!);
                          DateTime selectedDate = _selectedDay!;
                          final _selectedBills =
                              _groupedBills[selectedDate] ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.all(8.0),
                                child: TableCalendar(
                                  rowHeight: 70,
                                  focusedDay: _focusedDay,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(_selectedDay, day),
                                  firstDay: firstDay,
                                  lastDay: lastDay,
                                  eventLoader: _getBillsForDay,
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                      _selectedDay = selectedDay;
                                      _focusedDay = focusedDay;
                                    });
                                  },
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  calendarFormat: _calendarFormat,
                                  availableCalendarFormats: const {
                                    CalendarFormat.month: 'Month'
                                  },
                                  calendarStyle: const CalendarStyle(
                                      defaultTextStyle: TextStyle(fontSize: 20),
                                      weekendTextStyle:
                                          TextStyle(fontSize: 20)),
                                  calendarBuilders: CalendarBuilders(
                                    markerBuilder: (context, date, events) {
                                      if (events.isNotEmpty) {
                                        return Positioned(
                                          bottom: 1,
                                          right: 1,
                                          child: _buildEventsMarker(
                                              date, _groupedBills[date]!),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                  onDayLongPressed:
                                      (DateTime startDate, DateTime endDate) {
                                    setState(() {
                                      dateOfPaymentEditingController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(startDate);
                                    });

                                    FormDialog.showFormDialog(
                                        context: context,
                                        formContent: [
                                          billNameField,
                                          serviceProviderNameField,
                                          amountField,
                                          dateOfPaymentField,
                                          addButton
                                        ],
                                        key: _formKey,
                                        dialogHeader: 'Rachunek');
                                  },
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _selectedBills.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return BillsListTile(
                                      bill: _selectedBills[index]);
                                },
                              ),
                            ],
                          );
                        }
                        return const Text('');
                      });
                }
              }
              return const Text('');
            }),
        floatingActionButton: FloatingActionButton(
          child: const Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {},
        ));
  }

  _groupBills(List<Bill> bills) {
    _groupedBills = LinkedHashMap(equals: isSameDay);
    for (var bill in bills) {
      DateTime date = DateTime.utc(bill.dateOfPayment.year,
          bill.dateOfPayment.month, bill.dateOfPayment.day, 0);

      if (_groupedBills[date] == null) {
        _groupedBills[date] = [];
        _groupedBills[date]!.add(bill);
      } else {
        _groupedBills[date]!.add(bill);
      }
    }
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<dynamic> _getBillsForDay(DateTime date) {
    return _groupedBills[date] ?? [];
  }

  Widget _buildEventsMarker(DateTime date, List<Bill> bills) {
    if (bills.any((bill) => bill.isPaid == false)) {
      return const Center(
          child:
              Icon(Icons.new_releases, color: AppColors.toDoColor, size: 16));
    }

    return const Center(
        child: Icon(
      Icons.verified,
      color: AppColors.doneColor,
      size: 16,
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:housemanagement/core/base_colors.dart';
import 'package:housemanagement/screens/household/statistics/expenses/bills/bills_expenses_screen.dart';
import 'package:housemanagement/screens/household/statistics/expenses/shoppingList/shopping_list_expenses_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen>
    with SingleTickerProviderStateMixin {
  static const List<Tab> expensesTabs = <Tab>[
    Tab(text: 'Zakupy'),
    Tab(text: 'Rachunki')
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: expensesTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            child: TabBar(
              controller: _tabController,
              tabs: expensesTabs
                  .map((tab) => Center(
                        child: Text(
                          "${tab.text}",
                          style:
                              const TextStyle(color: AppBaseColors.blackColor),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        Expanded(
            flex: 14,
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                ShoppingListExpensesScreen(),
                BillsExpensesScreen()
              ],
            ))
      ],
    );
  }
}

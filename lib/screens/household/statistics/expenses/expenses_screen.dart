import 'package:flutter/material.dart';
import 'package:housemanagement/core/colors.dart';
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
            color: AppColors.primaryColorLight,
            child: TabBar(
              controller: _tabController,
              tabs: expensesTabs
                  .map((tab) => Center(
                        child: Text(
                          "${tab.text}",
                          style: const TextStyle(color: AppColors.blackColor),
                        ),
                      ))
                  .toList(),
              labelColor: AppColors.primaryColor,
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

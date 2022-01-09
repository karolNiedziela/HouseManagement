import 'package:flutter/material.dart';
import 'package:housemanagement/screens/household/household_screen.dart';
import 'package:housemanagement/screens/household/invitations/invitation_screen.dart';
import 'package:housemanagement/screens/household/statistics/expenses/expenses_screen.dart';
import 'package:housemanagement/services/household_service.dart';
import 'package:housemanagement/utils/form_dialog.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';

class BaseHouseholdScreen extends StatefulWidget {
  const BaseHouseholdScreen({Key? key}) : super(key: key);

  @override
  State<BaseHouseholdScreen> createState() => _BaseHouseholdScreenState();
}

class _BaseHouseholdScreenState extends State<BaseHouseholdScreen> {
  final householdService = HouseholdService();

  int _selectedIndex = 0;

  final List<Widget> _tabList = <Widget>[
    const HouseholdTestScreen(),
    const ExpensesScreen(),
    const InvitationScreen()
  ];

  final List<String> _titles = <String>[
    'Grupa domowa',
    'Wyliczenia',
    'Zaproszenia'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        actions: <Widget>[
          getPopupMenuWidget(),
        ],
      ),
      drawer: const DrawerWidget(),
      body: _tabList[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _selectedIndex != 2
          ? FloatingActionButton(
              child: const Text(''),
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {},
            )
          : null,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: "Członkowie"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: "Wyliczenia"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add), label: 'Zaproszenia')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getPopupMenuWidget() {
    return PopupMenuWidget(
      additionalPopupMenuItems: [
        AdditionalPopupMenuItem(
            onTap: () {
              FormDialog.showConfirmDeleteDialog(
                  context: context,
                  onYesPressed: () async {
                    await householdService.leaveHousehold();
                  },
                  text: 'Czy na pewno chcesz opuścić grupę domową?');
            },
            text: 'Opuść')
      ],
      isDeleteVisible: false,
      isEditVisible: false,
    );
  }
}

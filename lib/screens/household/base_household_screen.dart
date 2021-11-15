import 'package:flutter/material.dart';
import 'package:housemanagement/screens/household/household_tab.dart';
import 'package:housemanagement/screens/household/invitations_tests/invitation_tab.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';

class BaseHouseholdScreen extends StatefulWidget {
  const BaseHouseholdScreen({Key? key}) : super(key: key);

  @override
  State<BaseHouseholdScreen> createState() => _BaseHouseholdScreenState();
}

class _BaseHouseholdScreenState extends State<BaseHouseholdScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  TabController? _tabController;

  final List<Widget> _tabList = <Widget>[
    const HouseholdTestTab(),
    Container(
      color: Colors.blue,
    ),
    const InvitationTab()
  ];

  final List<String> _titles = <String>[
    'Grupa domowa',
    'Wyliczenia',
    'Zaproszenia'
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          centerTitle: true,
        ),
        drawer: const DrawerWidget(),
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: _tabList
        ),
           floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: 
            FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {     
                },
              ),
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
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _tabController!.animateTo(_selectedIndex);
  }
}

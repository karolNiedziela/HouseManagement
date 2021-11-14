import 'package:flutter/material.dart';
import 'package:housemanagement/models/household.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/services/household_service.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';

class HouseHouldScreen extends StatefulWidget {
  const HouseHouldScreen({Key? key}) : super(key: key);

  @override
  _HouseHouldScreenState createState() => _HouseHouldScreenState();
}

class _HouseHouldScreenState extends State<HouseHouldScreen> {
  final HouseholdService _householdService = HouseholdService();
  String fullName = '';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUserUId = AuthService().uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupa domowa"),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: StreamBuilder(
          stream: _householdService.household,
          builder: (context, AsyncSnapshot<Household> snapshot) {
            switch (snapshot.connectionState) {
              default:
                return ListView.builder(
                    itemCount:
                        snapshot.hasData ? snapshot.data!.users.length : 0,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                            leading: CircleAvatar(
                              child: Text(_getFirstLettersFromFullName(
                                  snapshot.data!.users[index].fullName)),
                            ),
                            title: snapshot.data!.users[index].isOwner
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          snapshot.data!.users[index].fullName),
                                      const Icon(Icons.star_border)
                                    ],
                                  )
                                : Text(snapshot.data!.users[index].fullName),
                            trailing: snapshot.data!.users
                                            .firstWhere(
                                                (element) => element.isOwner)
                                            .uid ==
                                        currentUserUId &&
                                    snapshot.data!.users[index].isOwner == false
                                ? PopupMenuWidget(
                                    deleteAction: () async {
                                      await _householdService
                                          .removeFromHouseHold(currentUserUId!,
                                              snapshot.data!.users[index].uid);
                                    },
                                    isEditVisible: false)
                                : null),
                      );
                    });
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
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

  String _getFirstLettersFromFullName(String fullName) {
    return fullName.trim().split(' ').map((word) => word[0]).join();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

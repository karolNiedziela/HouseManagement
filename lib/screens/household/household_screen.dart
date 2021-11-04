import 'package:flutter/material.dart';
import 'package:housemanagement/models/household.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/services/household_service.dart';
import 'package:housemanagement/widgets/trailing_popup_menu_widget.dart';

class HouseHouldScreen extends StatefulWidget {
  const HouseHouldScreen({Key? key}) : super(key: key);

  @override
  _HouseHouldScreenState createState() => _HouseHouldScreenState();
}

class _HouseHouldScreenState extends State<HouseHouldScreen> {
  final HouseholdService _householdService = HouseholdService();
  String fullName = '';

  @override
  Widget build(BuildContext context) {
    final currentUserUId = AuthService().uid;
    return StreamBuilder(
        stream: _householdService.household,
        builder: (context, AsyncSnapshot<Household> snapshot) {
          switch (snapshot.connectionState) {
            default:
              return Scaffold(
                body: ListView.builder(
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
                                ? TrailingPopupMenuWidget(
                                    deleteAction: () async {
                                    await _householdService.removeFromHouseHold(
                                        currentUserUId!,
                                        snapshot.data!.users[index].uid);
                                  })
                                : null),
                      );
                    }),
              );
          }
        });
  }

  _getFirstLettersFromFullName(String fullName) {
    return fullName.trim().split(' ').map((word) => word[0]).join();
  }
}

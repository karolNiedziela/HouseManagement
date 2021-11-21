import 'package:flutter/material.dart';
import 'package:housemanagement/models/household.dart';
import 'package:housemanagement/services/auth_service.dart';
import 'package:housemanagement/services/household_service.dart';
import 'package:housemanagement/widgets/popup_menu_widget.dart';

class HouseholdTestScreen extends StatefulWidget {
  const HouseholdTestScreen({Key? key}) : super(key: key);

  @override
  State<HouseholdTestScreen> createState() => _HouseholdTestScreenState();
}

class _HouseholdTestScreenState extends State<HouseholdTestScreen> {
  final HouseholdService _householdService = HouseholdService();

  String fullName = '';

  @override
  Widget build(BuildContext context) {
    final currentUserUId = AuthService().uid;

    return StreamBuilder(
        stream: _householdService.getHousehold(currentUserUId!),
        builder: (context, AsyncSnapshot<Household> snapshot) {
          switch (snapshot.connectionState) {
            default:
              return ListView.builder(
                  itemCount: snapshot.hasData ? snapshot.data!.users.length : 0,
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
                                    Text(snapshot.data!.users[index].fullName),
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
                                    await _householdService.removeFromHouseHold(
                                        currentUserUId,
                                        snapshot.data!.users[index].uid);
                                  },
                                  isEditVisible: false)
                              : null),
                    );
                  });
          }
        });
  }

  String _getFirstLettersFromFullName(String fullName) {
    return fullName.trim().split(' ').map((word) => word[0]).join();
  }
}

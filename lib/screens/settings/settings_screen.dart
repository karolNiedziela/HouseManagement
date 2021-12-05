import 'package:flutter/material.dart';
import 'package:housemanagement/widgets/change_theme_button_widget.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ustawienia"),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Row(
        children: const <Widget>[
          Expanded(
              child: Card(
                  child: ListTile(
            title: Text("Motywy"),
            trailing: ChangeThemeButtonWidget(),
          )))
        ],
      ),
    );
  }
}

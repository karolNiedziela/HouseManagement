import 'package:flutter/material.dart';
import 'package:housemanagement/widgets/drawer_widget.dart';

class MainScaffoldWidget extends StatelessWidget {
  final Widget body;
  final String appBarTitle;

  const MainScaffoldWidget(
      {Key? key, required this.body, required this.appBarTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: body,
    );
  }
}

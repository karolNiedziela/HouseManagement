import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(child: Text('data')),
        ),
        Expanded(
          flex: 13,
          child: GridView.builder(
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 18.0 / 10.0, crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                        color: Colors.blueAccent[100],
                        semanticContainer: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Sklep spożywczy bied',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0)),
                              Text('Karol Niedziela'),
                              Text('0/15')
                            ],
                          ),
                        )));
              }),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blueAccent[200],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
